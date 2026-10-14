/*!
 * Exponential Admin UI (exp_adminui): the resizable details panel of the content view.
 * The handle (.exp-adminui-details-resizer in preview.tpl) sits on the left edge of the panel (.node-info-list).
 * Dragging it (mouse, pen or touch, through pointer events) or the arrow keys on the focused handle change the
 * panel's width, kept in the CSS variable --exp-adminui-details-width on <html>. The width is saved once, at the end
 * of a drag or shortly after the last key press, in the user preference exp_adminui_details_width, the way the admin
 * designs save theirs (user/preferences/set_and_exit, $.ez.setPreference of ezjscore when it is loaded).
 * pagelayout.tpl reads the preference back and sets the variable on the server, so the page opens at that width.
 * GNU General Public License v2.0 (or any later version).
 */
( function ()
{
    'use strict';

    var PREFERENCE = 'exp_adminui_details_width',
        MIN = 200, MAX = 640, DEFAULT = 320,
        FLOOR = 160,             // where the room is short, the minimum gives way down to this
        MAIN_MIN = 360,          // the content next to the panel keeps at least this much (as in adminui.css)
        STEP = 16, BIG_STEP = 64,
        KEY_SAVE_DELAY = 600;

    function init( handle )
    {
        var preview = handle.parentNode,
            panel = document.getElementById( handle.getAttribute( 'aria-controls' ) ) || handle.nextElementSibling,
            root = document.documentElement,
            saved = currentWidth(),
            keyTimer = null,
            drag = null;

        if ( !panel || handle.getAttribute( 'data-exp-ready' ) )
            return;
        handle.setAttribute( 'data-exp-ready', '1' );

        function active()
        {
            // hidden by the stylesheet where the panel is stacked under the content
            return handle.offsetWidth > 0;
        }

        // the range follows the room beside the content, as the stylesheet's min-width and max-width do: on a narrow
        // window a width saved on a wide one is held in that room, and the minimum gives way where 200px do not fit
        function minWidth()
        {
            var room = preview.clientWidth - MAIN_MIN;
            return Math.max( FLOOR, Math.min( MIN, room ) );
        }

        function maxWidth()
        {
            var room = preview.clientWidth - MAIN_MIN;
            return Math.max( minWidth(), Math.min( MAX, room ) );
        }

        function clamp( width )
        {
            return Math.max( minWidth(), Math.min( maxWidth(), Math.round( width ) ) );
        }

        function currentWidth()
        {
            // the width pagelayout.tpl set from the preference, else the stylesheet's default
            return parseInt( root.style.getPropertyValue( '--exp-adminui-details-width' ), 10 ) || DEFAULT;
        }

        function describe( width )
        {
            handle.setAttribute( 'aria-valuenow', String( width ) );
            handle.setAttribute( 'aria-valuemin', String( minWidth() ) );
            handle.setAttribute( 'aria-valuemax', String( maxWidth() ) );
            handle.setAttribute( 'aria-valuetext', width + ' pixels' );
        }

        function apply( width )
        {
            width = clamp( width );
            root.style.setProperty( '--exp-adminui-details-width', width + 'px' );
            describe( width );
            return width;
        }

        function save( width )
        {
            if ( width === saved )
                return;
            saved = width;
            var jq = window.jQuery;
            if ( jq && jq.ez && jq.ez.setPreference )
            {
                jq.ez.setPreference( PREFERENCE, String( width ) );
                return;
            }
            var url = handle.getAttribute( 'data-preference-url' ),
                tokenNode = document.getElementById( 'ezxform_token_js' ),
                body = new FormData();
            if ( !url || !window.fetch )
                return;
            body.append( 'Function', 'set_and_exit' );
            body.append( 'Key', PREFERENCE );
            body.append( 'Value', String( width ) );
            if ( tokenNode )
                body.append( 'ezxform_token', tokenNode.getAttribute( 'title' ) );
            window.fetch( url, { method: 'POST', body: body, credentials: 'same-origin' } );
        }

        function onMove( event )
        {
            if ( !drag || event.pointerId !== drag.id )
                return;
            event.preventDefault();
            // the handle is on the left edge: moving left makes the panel wider
            drag.width = apply( drag.startWidth + ( drag.startX - event.clientX ) );
        }

        function onEnd( event )
        {
            if ( !drag || ( event && event.pointerId !== drag.id ) )
                return;
            var width = drag.width;
            if ( handle.releasePointerCapture && handle.hasPointerCapture && handle.hasPointerCapture( drag.id ) )
                handle.releasePointerCapture( drag.id );
            drag = null;
            handle.classList.remove( 'is-resizing' );
            document.body.classList.remove( 'exp-adminui-details-resizing' );
            handle.removeEventListener( 'pointermove', onMove );
            handle.removeEventListener( 'pointerup', onEnd );
            handle.removeEventListener( 'pointercancel', onEnd );
            save( width );
        }

        handle.addEventListener( 'pointerdown', function ( event )
        {
            if ( !active() || ( event.pointerType === 'mouse' && event.button !== 0 ) )
                return;
            event.preventDefault();
            var width = Math.round( panel.getBoundingClientRect().width );
            drag = { id: event.pointerId, startX: event.clientX, startWidth: width, width: width };
            if ( handle.setPointerCapture )
                handle.setPointerCapture( event.pointerId );
            handle.classList.add( 'is-resizing' );
            document.body.classList.add( 'exp-adminui-details-resizing' );
            handle.addEventListener( 'pointermove', onMove );
            handle.addEventListener( 'pointerup', onEnd );
            handle.addEventListener( 'pointercancel', onEnd );
        } );

        handle.addEventListener( 'keydown', function ( event )
        {
            if ( !active() )
                return;
            var width = Math.round( panel.getBoundingClientRect().width ),
                step = event.shiftKey ? BIG_STEP : STEP,
                next;
            switch ( event.key )
            {
                // the handle is on the left edge: left widens the panel, right narrows it
                case 'ArrowLeft': case 'ArrowUp': next = width + step; break;
                case 'ArrowRight': case 'ArrowDown': next = width - step; break;
                case 'Home': next = minWidth(); break;
                case 'End': next = maxWidth(); break;
                default: return;
            }
            event.preventDefault();
            next = apply( next );
            if ( keyTimer )
                window.clearTimeout( keyTimer );
            keyTimer = window.setTimeout( function () { keyTimer = null; save( next ); }, KEY_SAVE_DELAY );
        } );

        handle.addEventListener( 'dblclick', function ()
        {
            if ( active() )
                save( apply( DEFAULT ) );
        } );

        // aria-valuenow tells the width the panel really has (the stylesheet may hold it in its range, the window
        // may change size, the page may still be loading its stylesheets when this runs)
        function sync()
        {
            describe( active() ? Math.round( panel.getBoundingClientRect().width ) : clamp( saved ) );
        }
        if ( window.ResizeObserver )
            new window.ResizeObserver( sync ).observe( panel );
        window.addEventListener( 'resize', sync );
        window.addEventListener( 'load', sync );
        sync();
    }

    function start()
    {
        var handles = document.querySelectorAll( '.exp-adminui-details-resizer' );
        for ( var i = 0; i < handles.length; i++ )
            init( handles[i] );
    }

    if ( document.readyState === 'loading' )
        document.addEventListener( 'DOMContentLoaded', start );
    else
        start();
} )();
