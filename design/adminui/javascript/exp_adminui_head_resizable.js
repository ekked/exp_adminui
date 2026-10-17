/**
 * Exponential Admin UI: jQuery UI resizable for the left column (page_head_script.tpl), only where no jQuery UI is
 * loaded yet. The copy is jQuery UI 1.11 with its own widget factory; loaded over a page's newer jQuery UI (eztags'
 * tree picker) it broke that page's widgets. A jQuery UI without resizable gets a no-op, so the column simply keeps
 * its width.
 *
 * A normal (blocking) script in <head>: the copy is written in with document.write, so it is loaded before the
 * scripts after it, as before. Its address is the data-resizable attribute of this script's own tag.
 */
(function ()
{
    var me = document.currentScript, src = me ? me.getAttribute( 'data-resizable' ) : '';
    if ( !( window.jQuery && jQuery.ui ) )
    {
        if ( src )
            document.write( '<script type="text/javascript" src="' + src.replace( /"/g, '&quot;' ) + '"><\/script>' );
    }
    else if ( !jQuery.fn.resizable )
    {
        jQuery.fn.resizable = function () { return this; };
    }
})();
