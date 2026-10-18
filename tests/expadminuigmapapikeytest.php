<?php
/**
 * The adminui edit template of the ezgmaplocation field loads the Google Maps JavaScript API only with an API key, over
 * https from maps.googleapis.com, with the key URL-encoded: without a key Google draws no map, so the page loads nothing
 * from another host (and a Content Security Policy has nothing to allow). Reads the files only, without the kernel.
 *
 *   php tests/expadminuigmapapikeytest.php
 *
 *  GK-01 - no adminui template loads the Maps API from maps.google.com or a protocol-relative address
 *  GK-02 - the edit template loads it inside an {if} that requires a non-empty ApiKey, key |trim|urlencode'd
 *  GK-03 - exp_adminui_gmaplocation.js sets no map up when google.maps is undefined
 */

$failures = 0;
function gkCheck( $ok, $message )
{
    global $failures;
    echo ( $ok ? 'PASS' : 'FAIL' ), ": $message\n";
    if ( !$ok )
        $failures++;
}

$root = dirname( __DIR__ );
$bad = array();
$it = new RecursiveIteratorIterator( new RecursiveDirectoryIterator( $root . '/design', FilesystemIterator::SKIP_DOTS ) );
foreach ( $it as $file )
{
    if ( substr( (string)$file, -4 ) !== '.tpl' )
        continue;
    $source = preg_replace( '/\{\*.*?\*\}/s', '', file_get_contents( (string)$file ) );
    if ( preg_match( '#maps\.google\.com/maps/api|src="//maps\.#', $source ) )
        $bad[] = substr( (string)$file, strlen( $root ) + 1 );
}
gkCheck( !$bad, 'GK-01 no template loads the Maps API from maps.google.com or a protocol-relative address' . ( $bad ? ': ' . implode( ', ', $bad ) : '' ) );

$tpl = preg_replace( '/\{\*.*?\*\}/s', '', (string)@file_get_contents( $root . '/design/adminui/templates/content/datatype/edit/ezgmaplocation.tpl' ) );
gkCheck( (bool)preg_match( "#\{if and\( ezini_hasvariable\( 'GMapSettings', 'ApiKey', 'ezgmaplocation\.ini' \), ezini\( 'GMapSettings', 'ApiKey', 'ezgmaplocation\.ini' \)\|trim\|ne\( '' \) \)\}\s*"
                                 . "<script type=\"text/javascript\" src=\"https://maps\.googleapis\.com/maps/api/js\?key=\{ezini\( 'GMapSettings', 'ApiKey', 'ezgmaplocation\.ini' \)\|trim\|urlencode\}\"></script>\s*\{/if\}#", $tpl ),
         'GK-02 the edit template loads the Maps API only with a non-empty ApiKey, from https://maps.googleapis.com' );

$js = (string)@file_get_contents( $root . '/design/adminui/javascript/exp_adminui_gmaplocation.js' );
gkCheck( (bool)preg_match( "#function setUp\(\)\s*\{[^}]*typeof google === 'undefined' \|\| !google\.maps\s*\)\s*return;#", $js ),
         'GK-03 the script sets no map up without the API' );

echo $failures ? "FAIL: $failures\n" : "PASS: all\n";
exit( $failures ? 1 : 0 );
