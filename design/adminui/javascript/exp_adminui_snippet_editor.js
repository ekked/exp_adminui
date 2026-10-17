/**
 * Exponential Admin UI: the snippet editor (Ace) of a text block attribute (content/datatype/edit/eztext.tpl, for the
 * classes and attributes of exp_adminui.ini [SnippetEditorSettings]). Every div.snippet-editor[data-expui-ace] becomes
 * an Ace editor that writes into the text area named by its id; its settings are the data-expui-ace-* attributes
 * (mode, theme, print margin, active line). The text area is hidden. Printed once per attribute: sets up every
 * editor once, when the page is ready.
 */
(function ( $ )
{
    function flag( value, fallback )
    {
        if ( value === null || value === undefined || value === '' )
            return fallback;
        return !( value === 'false' || value === '0' );
    }

    function setUp()
    {
        if ( !window.ace )
            return;
        $( 'div.snippet-editor[data-expui-ace]' ).each( function ()
        {
            if ( this.getAttribute( 'data-expui-ace-ready' ) )
                return;
            this.setAttribute( 'data-expui-ace-ready', '1' );

            var editor = ace.edit( this.id );
            editor.setTheme( 'ace/theme/' + ( this.getAttribute( 'data-expui-ace-theme' ) || 'chrome' ) );
            editor.session.setMode( 'ace/mode/' + ( this.getAttribute( 'data-expui-ace-mode' ) || 'html' ) );
            editor.setOptions( { enableBasicAutocompletion: true } );
            editor.commands.on( 'afterExec', function ( e )
            {
                if ( e.command.name == 'insertstring' && /^[<.]$/.test( e.args ) )
                    editor.execCommand( 'startAutocomplete' );
            } );
            editor.setShowPrintMargin( flag( this.getAttribute( 'data-expui-ace-print-margin' ), false ) );
            editor.setHighlightActiveLine( flag( this.getAttribute( 'data-expui-ace-active-line' ), true ) );

            var textarea = $( 'textarea[name="' + this.id + '"]' ).hide();
            editor.getSession().setValue( textarea.val() );
            editor.getSession().on( 'change', function ()
            {
                textarea.val( editor.getSession().getValue().trim() );
            } );
        } );
    }

    $( setUp );
})( jQuery );
