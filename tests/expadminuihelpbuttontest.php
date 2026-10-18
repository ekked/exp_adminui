<?php
/**
 * The context Help control of the Admin UI header (adminui/parts/help_button.tpl): it links to the help page of the
 * module and view on screen through the kernel's help system, and only where that exists and the user may read it.
 * Reads the files only, without the kernel.
 *
 *   php tests/expadminuihelpbuttontest.php
 *
 *  HB-01 - pagelayout.tpl includes the part inside the header
 *  HB-02 - the part asks the kernel only when module.ini lists the exphelp module (an older kernel draws nothing)
 *  HB-03 - it fetches exphelp/context for the request's module and view and the siteaccess design, and draws the
 *          link only for a result (false: no exphelp/read)
 *  HB-04 - the link has an accessible name that contains its visible label, and its icon is hidden from assistive
 *          technology
 *  HB-05 - the aui-help classes are in adminui-pages.css, with a focus ring
 *  HB-06 - no inline style or script in the part
 *  HB-07 - the Help menu is a <details> disclosure, asked for only when exphelp.ini has [ContextHelp] MenuLinks (a
 *          kernel with fetch exphelp/context_menu), with the search, the help for this page and the Help center
 *  HB-08 - Escape closes the open Help menu and gives the focus back to its summary (exp_adminui_aside_dropdown_keys.js,
 *          loaded on every page by page_head_script.tpl)
 */

$failures = 0;
function hbCheck( $ok, $message )
{
    global $failures;
    echo ( $ok ? 'PASS' : 'FAIL' ), ": $message\n";
    if ( !$ok )
        $failures++;
}

$root = dirname( __DIR__ );
$strip = function ( $source ) { return preg_replace( '/\{\*.*?\*\}/s', '', (string)$source ); };
$layout = $strip( @file_get_contents( $root . '/design/adminui/templates/pagelayout.tpl' ) );
$part = $strip( @file_get_contents( $root . '/design/adminui/templates/adminui/parts/help_button.tpl' ) );
$css = (string)@file_get_contents( $root . '/design/adminui/stylesheets/adminui-pages.css' );

hbCheck( (bool)preg_match( "#<header id=\"header\">.*\{include uri='design:adminui/parts/help_button\.tpl'\}.*</header>#s", $layout ),
         'HB-01 the header includes adminui/parts/help_button.tpl' );
hbCheck( strpos( ltrim( $part ), "{if ezini( 'ModuleSettings', 'ModuleList', 'module.ini' )|contains( 'exphelp' )}" ) === 0,
         'HB-02 the part starts with the exphelp module check' );
hbCheck( (bool)preg_match( "#fetch\( 'exphelp', 'context', hash\( 'module', first_set\( \\\$adminui_help_mp\.module_name, '' \),\s*'view', first_set\( \\\$adminui_help_mp\.function_name, '' \),\s*'design', ezini\( 'DesignSettings', 'SiteDesign', 'site\.ini' \) \) \)#", $part )
         && (bool)preg_match( '#\{if \$adminui_help_ctx\}.*<a class="aui-help-btn" href=\{\$adminui_help_ctx\.url\|ezurl\}#s', $part ),
         'HB-03 the link is drawn from the context fetch, only for a result' );
hbCheck( (bool)preg_match( '#aria-label="\{\$adminui_help_label\|wash\}"#', $part )
         && strpos( $part, "'Help for this page'|i18n( 'kernel/exphelp' )" ) !== false
         && strpos( $part, "'Help: %title'|i18n( 'kernel/exphelp'" ) !== false
         && strpos( $part, '<i class="fa fa-question-circle" aria-hidden="true"></i>' ) !== false
         && strpos( $part, "<span class=\"aui-help-label\">{'Help'|i18n( 'kernel/exphelp' )}</span>" ) !== false,
         'HB-04 accessible name with the visible label, icon hidden' );
hbCheck( strpos( $css, '.aui-help {' ) !== false && strpos( $css, '.aui-help-btn {' ) !== false
         && strpos( $css, '.aui-help-btn:focus-visible { outline:' ) !== false,
         'HB-05 the classes are in adminui-pages.css, with a focus ring' );
hbCheck( !preg_match( '#style=|<style|<script|\son[a-z]+=#i', $part ), 'HB-06 no inline style or script in the part' );

hbCheck( (bool)preg_match( '#\{if ezini_hasvariable\( \'ContextHelp\', \'MenuLinks\', \'exphelp\.ini\' \)\}\s*\{set \$adminui_help_menu = fetch\( \'exphelp\', \'context_menu\'#', $part )
         && strpos( $part, '<details class="aui-help-menu">' ) !== false && strpos( $part, '<summary class="aui-help-btn"' ) !== false
         && strpos( $part, "action={'/exphelp/search'|ezurl} method=\"get\" role=\"search\"" ) !== false
         && strpos( $part, "href={'/exphelp/dashboard'|ezurl}" ) !== false
         && strpos( $css, '.aui-help-panel {' ) !== false,
         'HB-07 the Help menu: a disclosure, only with the context_menu kernel, search + page help + Help center' );

$keys = (string)@file_get_contents( $root . '/design/adminui/javascript/exp_adminui_aside_dropdown_keys.js' );
$head = $strip( @file_get_contents( $root . '/design/adminui/templates/page_head_script.tpl' ) );
hbCheck( strpos( $keys, "'details.aui-help-menu[open]'" ) !== false && strpos( $keys, "e.key !== 'Escape'" ) !== false
         && strpos( $keys, "open.removeAttribute( 'open' )" ) !== false && strpos( $keys, 'summary.focus()' ) !== false
         && strpos( $head, 'exp_adminui_aside_dropdown_keys.js' ) !== false,
         'HB-08 Escape closes the Help menu and focuses its summary' );

echo $failures ? "FAIL: $failures\n" : "PASS: all\n";
exit( $failures ? 1 : 0 );
