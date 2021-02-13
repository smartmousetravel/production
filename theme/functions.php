<?php
/**
 * Smart Mouse Travel Theme functions and definitions
 *
 * @link https://developer.wordpress.org/themes/basics/theme-functions/
 * @package Smart Mouse Travel
 * @since 0.9.0
 */

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
    'style_loader_tag',
    function($html, $handle) {
        if (is_admin()) {
            return $html;
        }
        $myhandles = array(
            'astra-addon-css',
            'wp-block-library');
        if (in_array($handle, $myhandles)) {
            $html = str_replace(
                "rel='stylesheet'",
                'rel="preload" as="style" onload="this.onload=null;this.rel=\'stylesheet\'"',
                $html);
        }
        return $html;
    },
    10 /* default priority */,
    2  /* args to pass to filter closure */);
