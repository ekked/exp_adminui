/*!
 * Exponential Admin UI (exp_adminui): the keyboard in the side bar's dropdowns (menu/aside.tpl: Cache, Bookmarks,
 * Interface). Bootstrap 3 drives them (app.js), and its key handler on .dropdown-menu does not fit them: Escape inside
 * an open dropdown clicked the dropdown itself, which app.js stops, so it stayed open; and it cancelled Space and the
 * arrow keys on everything that is not a text field or a link, so Space did not press a button and the arrow keys did
 * not move through the language list. This handler runs first, on the dropdown itself:
 * - Escape closes the open dropdown and puts the focus back on its toggle;
 * - in the Interface dropdown the language list and the buttons keep their own keys, and the design choices follow
 *   the menu pattern of the other administration designs: Down, Up, Home and End move through them.
 * GNU General Public License v2.0 (or any later version).
 */
( function ( $ )
{
    'use strict';

    if ( !$ || !$.fn.dropdown )
        return;

    $( function ()
    {
        $( '.navi-wrap .aside-dropdown > .dropdown-menu' ).on( 'keydown', function ( e )
        {
            var key = e.key,
                $item = $( this ).parent(),
                $toggle = $item.children( '.aside-dropdown-toggle' ),
                $options, index;

            if ( key === 'Escape' || key === 'Esc' )
            {
                e.preventDefault();
                e.stopPropagation();
                if ( $item.hasClass( 'open' ) )
                    $toggle.dropdown( 'toggle' );
                $toggle.trigger( 'focus' );
                return;
            }
            if ( !$( e.target ).closest( '#uiswitch-tool' ).length )
                return;

            if ( $( e.target ).is( '.a4-uiswitch-option' ) && /^(ArrowDown|ArrowUp|Home|End|Down|Up)$/.test( key ) )
            {
                $options = $( e.target ).closest( '.a4-uiswitch-list' ).find( '.a4-uiswitch-option:visible' );
                index = $options.index( e.target );
                if ( key === 'ArrowDown' || key === 'Down' )
                    index = Math.min( index + 1, $options.length - 1 );
                else if ( key === 'ArrowUp' || key === 'Up' )
                    index = Math.max( index - 1, 0 );
                else if ( key === 'Home' )
                    index = 0;
                else
                    index = $options.length - 1;
                e.preventDefault();
                $options.eq( index ).trigger( 'focus' );
            }
            // keep Bootstrap's handler away from the form controls of this dropdown
            e.stopPropagation();
        } );
    } );
}( window.jQuery ) );

/* The header's Help menu (adminui/parts/help_button.tpl) is a native <details> disclosure, which browsers do not close
   with Escape or a click elsewhere: Escape closes the open menu and puts the focus back on its button (the <summary>),
   and a click outside it closes it. Delegated on the document, without jQuery. */
( function () {
    var SELECTOR = 'details.aui-help-menu[open]';
    document.addEventListener( 'keydown', function ( e ) {
        if ( e.key !== 'Escape' && e.key !== 'Esc' )
            return;
        var open = document.querySelector( SELECTOR );
        if ( !open )
            return;
        open.removeAttribute( 'open' );
        var summary = open.querySelector( 'summary' );
        if ( summary )
            summary.focus();
        e.preventDefault();
    } );
    document.addEventListener( 'click', function ( e ) {
        var open = document.querySelector( SELECTOR );
        if ( open && !open.contains( e.target ) )
            open.removeAttribute( 'open' );
    } );
}() );
