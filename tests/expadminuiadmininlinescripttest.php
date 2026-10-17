<?php
/**
 * The admin templates of exp_adminui carry no inline JavaScript: no <script> with code, no on...= handler attribute and
 * no javascript: link. A Content-Security-Policy without 'unsafe-inline' in script-src blocks those; the code is in
 * files of design/adminui/javascript, the values it needs in data-* attributes. Reads the files only, without the
 * kernel.
 *
 * Run directly with:
 *   php tests/expadminuiadmininlinescripttest.php
 *
 *  IS-01 - no inline script, handler attribute or javascript: link in the templates (template comments left out),
 *          except the TinyMCE 3 edit template (ezxmltext_ezoe.tpl: the editor engine needs its inline start script)
 *  IS-02 - every file a template prints with ezscript() or links from javascript/ exists in design/adminui/javascript
 *  IS-03 - every data-expui-* action attribute of the templates is handled by exp_adminui_actions.js
 *  IS-04 - page_head_script.tpl loads exp_adminui_actions.js on every page
 */

$failures = 0;
function isCheck( $ok, $message )
{
    global $failures;
    echo ( $ok ? 'PASS' : 'FAIL' ), ": $message\n";
    if ( !$ok )
        $failures++;
}

$root = dirname( __DIR__ );
$allowed = array( 'design/adminui/templates/content/datatype/edit/ezxmltext_ezoe.tpl' );

$templates = array();
foreach ( glob( $root . '/design/{admin,admin2,admin3,admin4,admin4l,adminui}', GLOB_BRACE | GLOB_ONLYDIR ) as $dir )
{
    $it = new RecursiveIteratorIterator( new RecursiveDirectoryIterator( $dir, FilesystemIterator::SKIP_DOTS ) );
    foreach ( $it as $file )
        if ( substr( (string)$file, -4 ) === '.tpl' )
            $templates[substr( (string)$file, strlen( $root ) + 1 )] = preg_replace( '/\{\*.*?\*\}/s', '', file_get_contents( (string)$file ) );
}
ksort( $templates );

// IS-01
$inline = array();
foreach ( $templates as $path => $source )
{
    if ( in_array( $path, $allowed, true ) )
        continue;
    $found = 0;
    if ( preg_match_all( '/<script\b([^>]*)>/i', $source, $scripts ) )
        foreach ( $scripts[1] as $attributes )
            if ( !preg_match( '/\ssrc\s*=/i', $attributes ) && !preg_match( '/\stype\s*=\s*["\']?(application\/(ld\+)?json|text\/template)/i', $attributes ) )
                $found++;
    if ( preg_match_all( '/<[a-z][^<>]*>/is', $source, $tags ) )
        foreach ( $tags[0] as $tag )
            $found += preg_match_all( '/\son[a-z]+\s*=\s*["\'{]/i', $tag );
    $found += preg_match_all( '/\b(?:href|action|src|formaction)\s*=\s*["\']?\s*javascript:/i', $source );
    if ( $found )
        $inline[] = "$path ($found)";
}
isCheck( count( $templates ) > 0 && !$inline, 'IS-01 no inline script in ' . count( $templates ) . ' admin templates' . ( $inline ? ': ' . implode( ', ', $inline ) : '' ) );

// IS-02
$missing = array();
foreach ( $templates as $path => $source )
{
    preg_match_all( '/ezscript(?:_require)?\(\s*array\(\s*([^)]*)\)/', $source, $m );
    foreach ( $m[1] as $list )
        foreach ( preg_split( '/\s*,\s*/', trim( $list ) ) as $item )
        {
            $name = trim( $item, " '\"" );
            if ( strpos( $name, 'exp_adminui_' ) === 0 && !is_file( "$root/design/adminui/javascript/$name" ) )
                $missing[] = "$path: $name";
        }
    preg_match_all( "/\{'javascript\/(exp_adminui_[\w.]+\.js)'\|ezdesign/", $source, $m );
    foreach ( $m[1] as $name )
        if ( !is_file( "$root/design/adminui/javascript/$name" ) )
            $missing[] = "$path: $name";
}
isCheck( !$missing, 'IS-02 every script file the templates print exists' . ( $missing ? ': ' . implode( ', ', $missing ) : '' ) );

// IS-03 (data-expui-* attributes that only carry a value for another one, or are read by a page script, are listed)
$actions = (string)@file_get_contents( "$root/design/adminui/javascript/exp_adminui_actions.js" );
$values = array( 'data-expui-form', 'data-expui-reveal-focus', 'data-expui-initial' );
$unhandled = array();
foreach ( $templates as $path => $source )
    if ( preg_match_all( '/\b(data-expui-[a-z-]+)/', $source, $m ) )
        foreach ( array_unique( $m[1] ) as $attribute )
        {
            if ( in_array( $attribute, $values, true ) || strpos( $actions, $attribute ) !== false )
                continue;
            $handled = false;
            foreach ( glob( "$root/design/adminui/javascript/exp_adminui_*.js" ) as $file )
                if ( strpos( (string)file_get_contents( $file ), $attribute ) !== false )
                    $handled = true;
            if ( !$handled )
                $unhandled[$attribute] = $path;
        }
isCheck( !$unhandled, 'IS-03 every data-expui-* attribute is read by a script' . ( $unhandled ? ': ' . json_encode( $unhandled ) : '' ) );

// IS-04
$head = (string)@file_get_contents( "$root/design/adminui/templates/page_head_script.tpl" );
isCheck( strpos( $head, "'javascript/exp_adminui_actions.js'|ezdesign" ) !== false, 'IS-04 page_head_script.tpl loads exp_adminui_actions.js' );

echo $failures ? "FAIL: $failures\n" : "PASS: all\n";
exit( $failures ? 1 : 0 );
