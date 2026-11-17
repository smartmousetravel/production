import argparse
import base64
import hashlib
import json
import time
from typing import Dict, Iterable, Literal, Optional, Sequence

import requests

DEFAULT_PLUGINS: tuple[str, ...] = (
    # "astra-addon",
    "astra-widgets",
    "force-regenerate-thumbnails",
    "gutenberg",
    "header-footer-code-manager",
    "mediavine-control-panel",
    "mediavine-create",
    "pdf-embedder",
    "web-stories",
    "wordpress-seo",
)
DEFAULT_THEMES: tuple[str, ...] = ("astra",)


def _get_wp_asset_info(asset_type: Literal["plugin", "theme"], slug: str) -> Dict[str, str]:
    if asset_type == "plugin":
        url = f"https://api.wordpress.org/plugins/info/1.2/?action=plugin_information&request[slug]={slug}"
    elif asset_type == "theme":
        url = f"https://api.wordpress.org/themes/info/1.2/?action=theme_information&request[slug]={slug}"

    response = requests.get(url)
    response.raise_for_status()
    data = json.loads(response.text)
    version = data["version"]
    download_url = data["download_link"]

    download_response = requests.get(download_url)
    download_response.raise_for_status()
    sha256_hash = hashlib.sha256(download_response.content).digest()

    return {
        "version": version,
        "url": download_url,
        "hash": f"sha256-{base64.b64encode(sha256_hash).decode('utf-8')}",
    }


def get_theme_info(theme_slug: str) -> Dict[str, str]:
    return _get_wp_asset_info("theme", theme_slug)


def get_plugin_info(plugin_slug: str) -> Dict[str, str]:
    return _get_wp_asset_info("plugin", plugin_slug)


def _parse_args(argv: Optional[Sequence[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Fetch WordPress plugin and theme metadata and SHA-256 hashes as JSON."
    )
    parser.add_argument(
        "--plugin",
        dest="plugins",
        action="append",
        help="Plugin slug to fetch (repeatable; defaults to built-in plugin list).",
    )
    parser.add_argument(
        "--theme",
        dest="themes",
        action="append",
        help="Theme slug to fetch (repeatable; defaults to built-in theme list).",
    )
    return parser.parse_args(argv)


def main(
    plugin_slugs: Optional[Iterable[str]] = None,
    theme_slugs: Optional[Iterable[str]] = None,
) -> None:
    if plugin_slugs is None and theme_slugs is None:
        args = _parse_args()
        if args.plugins is None and args.themes is None:
            resolved_plugins: Iterable[str] = DEFAULT_PLUGINS
            resolved_themes: Iterable[str] = DEFAULT_THEMES
        else:
            resolved_plugins = args.plugins or ()
            resolved_themes = args.themes or ()
    else:
        resolved_plugins = DEFAULT_PLUGINS if plugin_slugs is None else plugin_slugs
        resolved_themes = DEFAULT_THEMES if theme_slugs is None else theme_slugs

    plugin_info: Dict[str, Dict[str, str]] = {}
    theme_info: Dict[str, Dict[str, str]] = {}

    for slug in resolved_plugins:
        plugin_info[slug] = get_plugin_info(slug)
        time.sleep(0.5)  # avoid rate limits
    for slug in resolved_themes:
        theme_info[slug] = get_theme_info(slug)
        time.sleep(0.5)  # avoid rate limits

    print(
        json.dumps(
            {
                "plugins": plugin_info,
                "themes": theme_info,
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
