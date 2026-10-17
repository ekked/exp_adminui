/**
 * Exponential Admin UI: the extension step of the package creator (package/creators/ezextension/extension.tpl):
 * the name or the info link of an extension opens its card, the close button closes it.
 */
jQuery(function() {
    function toggleExtensionCard( name ) {
        var row = jQuery( '#extension-card-' + name );
        var wasVisible = row.is(':visible');
        jQuery( '.extension-card-row' ).hide();
        if ( !wasVisible ) {
            row.show();
        }
    }

    jQuery( '.extension-name-link, .extension-info-link' ).on( 'click', function( e ) {
        e.preventDefault();
        toggleExtensionCard( jQuery(this).data('name') );
    });

    jQuery( '.extension-card-close' ).on( 'click', function( e ) {
        e.preventDefault();
        jQuery(this).closest( '.extension-card-row' ).hide();
    });
});
