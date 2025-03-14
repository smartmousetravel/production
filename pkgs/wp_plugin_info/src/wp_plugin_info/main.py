import base64
import hashlib
import json
import time
from typing import Dict, Iterable, Literal

import requests


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


def main(plugin_slugs: Iterable[str], theme_slugs: Iterable[str]) -> None:
    plugin_info: Dict[str, Dict[str, str]] = {}
    theme_info: Dict[str, Dict[str, str]] = {}

    for slug in plugin_slugs:
        plugin_info[slug] = get_plugin_info(slug)
        time.sleep(0.5)  # avoid rate limits
    for slug in theme_slugs:
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
    plugins = [
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
    ]
    themes = ["astra"]
    main(plugin_slugs=plugins, theme_slugs=themes)
