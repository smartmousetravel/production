<?php
/**
 * Smart Mouse Travel Theme functions and definitions
 *
 * @link https://developer.wordpress.org/themes/basics/theme-functions/
 * @package Smart Mouse Travel
 */

DEFINE("SMT_THEME_VERSION", "0.9.4");

/*
 * Defer loading of some selected styles. Empirically this saves about
 * 16 KB (uncompressed) of rendering blocking CSS.
 *
 * You can add 'astra-theme-css' to the list of styles to defer, but that
 * trades speed for rendering jank (moves the CLS web vitals metric from zero
 * to 0.8, where "good" values are < 0.1).
 *
 * See <https://web.dev/defer-non-critical-css>
 */
add_filter(
    "style_loader_tag",
    function ($html, $handle) {
        if (is_admin()) {
            return $html;
        }
        $myhandles = ["astra-addon-css", "wp-block-library"];
        if (in_array($handle, $myhandles)) {
            $html = str_replace(
                "rel='stylesheet'",
                'rel="preload" as="style" onload="this.onload=null;this.rel=\'stylesheet\'"',
                $html
            );
        }
        return $html;
    },
    10,
    2
);

/*
 * Load CSS and JavaScript for async embedding for YouTube videos, inspired
 * by <https://www.labnol.org/internet/light-youtube-embeds/27941/>
 */
add_action("wp_enqueue_scripts", function () {
    wp_enqueue_script(
        "smt-youtube",
        get_theme_file_uri("/youtube.min.js"),
        [],
        SMT_THEME_VERSION,
        true
    );
});

/*
 * Work around Yoast bug 17419[1], which is a regression that causes
 * rel=canonical to be rendered multiple times, once by the web stories
 * renderer and once by Yoast.
 *
 * 1. https://github.com/Yoast/wordpress-seo/issues/17419
 */
add_action("template_redirect", function () {
    if (!is_singular("web-story")) {
        return;
    }
    $front_end = YoastSEO()->classes->get(
        Yoast\WP\SEO\Integrations\Front_End_Integration::class
    );
    remove_action("wpseo_head", [$front_end, "present_head"], -9999);
});

/*
 * Display last-modified date instead of published date in Astra
 * metadata. This is loosely based on the advice in the Astra docs[1]. That
 * code is insane (it appends the empty string to the end of something three
 * times?), so I cribbed markup from the parent theme source[2] to make sure
 * we retain styling in future upgrades. Why this can't be fixed in CSS
 * instead is completely beyond me.
 *
 * 1. <https://wpastra.com/docs/show-last-updated-not-published-date>
 * 2. <https://github.com/brainstormforce/astra/blob/172c9b26e7/inc/blog/blog-config.php#L92>
 */
add_filter("astra_post_date", function () {
    $format = apply_filters("astra_post_date_format", "");
    $dt = esc_html(get_the_modified_date($format));
    return "<span class='posted-on'><span class='published' itemprop='datePublished'>{$dt}</span></span>";
});
?>
