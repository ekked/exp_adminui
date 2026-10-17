/**
 * Exponential Admin UI: the languages page (content/translations.tpl): before a removal it says which languages go
 * and which siteaccesses still list them. The texts are the data-expui-text attribute (JSON) of #language-form.
 */
var expLanguageText = JSON.parse( ( document.getElementById( 'language-form' ) || document.documentElement ).getAttribute( 'data-expui-text' ) || '{}' );
(function () {
    var form = document.getElementById( 'language-form' );
    if ( !form ) return;
    var removing = false;
    form.addEventListener( 'click', function ( e ) {
        removing = !!( e.target.closest && e.target.closest( '#language-remove' ) );
    } );
    // Before a removal, say which languages go and which siteaccesses still list them.
    form.addEventListener( 'submit', function ( e ) {
        if ( !removing ) return;
        var picked = form.querySelectorAll( 'input[name="DeleteIDArray[]"]:checked' ), lines = [], i;
        if ( !picked.length ) { e.preventDefault(); window.alert( expLanguageText.none ); return; }
        for ( i = 0; i < picked.length; i++ ) {
            var line = '- ' + picked[i].getAttribute( 'data-name' );
            var sites = picked[i].getAttribute( 'data-sites' );
            if ( sites ) line += '\n  ' + expLanguageText.listed.split( '%sites' ).join( sites );
            lines.push( line );
        }
        if ( !window.confirm( expLanguageText.confirm + '\n\n' + lines.join( '\n' ) ) ) e.preventDefault();
    } );
})();
