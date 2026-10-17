/**
 * Exponential Admin UI: the content edit page (content/edit.tpl).
 *
 * - The object information column (#objectinfo-showhide) folds and unfolds; the state is remembered per user, as
 *   Exponential's own edit page does it (Exponential UI preferences). The reference did this with YUI 3
 *   (ezcollapsiblemenu); Exponential 6 has no YUI, so this toggles the same class and stores the same preference.
 * - Enter in a field of the edit form (not a text area) does not send the form.
 * - confirmDiscard( question ) clears the form's DiscardConfirm field and asks (the Discard buttons use
 *   data-expui-discard-confirm of exp_adminui_actions.js; the function stays for other templates that call it).
 */
(function ( $ )
{
    if ( window.expAdminUIContentEdit )
        return;
    window.expAdminUIContentEdit = true;

    window.confirmDiscard = function ( question )
    {
        // Disable/bypass the reload-based (plain HTML) confirmation interface.
        if ( document.editform && document.editform.DiscardConfirm )
            document.editform.DiscardConfirm.value = '0';
        return window.confirm( question );
    };

    $( function ()
    {
        $( '#objectinfo-showhide' ).on( 'click', function ( e )
        {
            e.preventDefault();
            var menu = $( '.rightmenu' ).toggleClass( 'closed' ), collapsed = menu.hasClass( 'closed' );
            menu.css( 'margin-right', collapsed ? '-222px' : '0' );
            if ( window.Exp && window.Exp.prefs && window.Exp.prefs.set )
                window.Exp.prefs.set( 'admin_edit_menu_collapsed', collapsed ? 1 : 0 ).catch( function () {} );
            else if ( $.ez && $.ez.setPreference )
                $.ez.setPreference( 'admin_edit_menu_collapsed', collapsed ? 1 : 0 );
        } );

        $( '#editform' ).on( 'keypress keydown keyup', ':input:not(textarea)', function ( e )
        {
            if ( e.keyCode == 13 )
                e.preventDefault();
        } );
    } );
})( jQuery );
