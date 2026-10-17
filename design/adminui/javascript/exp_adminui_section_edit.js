/**
 * Exponential Admin UI: the section edit form (section/edit.tpl): the field to fix is focused, a new section's
 * identifier follows its name until it is typed in, and the identifier is checked before the form is sent. The
 * values are data-expui-* attributes of #section-edit-form. Printed after the form.
 */
var expSectionEditForm = document.getElementById( 'section-edit-form' ) || document.documentElement;
var expSectionEditNew = expSectionEditForm.getAttribute( 'data-expui-new' ) === '1';
var expSectionEditError = expSectionEditForm.getAttribute( 'data-expui-error' ) === '1';
var expSectionEditText = JSON.parse( expSectionEditForm.getAttribute( 'data-expui-text' ) || '{}' );
(function () {
    var nameEl = document.getElementById( 'sectionName' );
    var idEl = document.getElementById( 'SectionIdentifier' );
    if ( !nameEl || !idEl ) return;
    if ( expSectionEditError ) {
        var box = document.getElementById( 'section-edit-error' );
        idEl.focus(); idEl.select();
        if ( box ) box.setAttribute( 'aria-live', 'assertive' );
    } else {
        nameEl.focus(); nameEl.select();
    }
    // A new section's identifier follows its name ("Members area" -> "members_area") until it is typed in.
    var typed = !expSectionEditNew || idEl.value !== '';
    idEl.addEventListener( 'input', function () { typed = idEl.value !== ''; idEl.setCustomValidity( '' ); } );
    nameEl.addEventListener( 'input', function () {
        if ( typed ) return;
        var s = nameEl.value.toLowerCase();
        if ( s.normalize ) s = s.normalize( 'NFD' ).replace( /[̀-ͯ]/g, '' );
        s = s.replace( /ß/g, 'ss' ).replace( /[^a-z0-9_]+/g, '_' ).replace( /^[^a-z]+/, '' ).replace( /_+$/, '' );
        idEl.value = s;
    } );
    // The same checks as the server, before the round trip; the server still has the last word.
    document.getElementById( 'section-edit-form' ).addEventListener( 'submit', function ( e ) {
        var store = e.submitter ? e.submitter.name === 'StoreButton' : true;
        if ( !store ) return;
        var v = idEl.value.trim();
        var msg = v === '' ? expSectionEditText.empty : ( /^[A-Za-z][A-Za-z0-9_]*$/.test( v ) ? '' : expSectionEditText.pattern );
        idEl.setCustomValidity( msg );
        if ( msg ) { e.preventDefault(); idEl.setAttribute( 'aria-invalid', 'true' ); idEl.reportValidity(); idEl.focus(); }
    } );
})();
