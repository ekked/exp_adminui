/**
 * Exponential Admin UI: app.js points Ace at the bundle's public path; point it at this design's copy. The path is
 * the data-base-path attribute of this script's own tag (page_head_script.tpl).
 */
(function ()
{
    var me = document.currentScript, path = me ? me.getAttribute( 'data-base-path' ) : '';
    if ( window.ace && path )
        ace.config.set( 'basePath', path );
})();
