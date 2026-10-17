/**
 * Exponential Admin UI: the language choice before editing (content/edit_languages.tpl): the source translations
 * can only be picked for a new translation, not when an existing one is edited.
 */
(function( $ )
{
    if ( document.getElementById('ezcoeditlanguages-sourcets') )
    {
        // setup onchange events
        jQuery( '#ezcoeditlanguages-existingts input[type=radio]' ).on('change', function()
        {
            jQuery( '#ezcoeditlanguages-sourcets input[type=radio]' ).prop( 'disabled', true );
        });
        jQuery( '#ezcoeditlanguages-newts input[type=radio]' ).on('change', function()
        {
            jQuery( '#ezcoeditlanguages-sourcets input[type=radio]' ).prop( 'disabled', false );
        });

        // disable source translations if existing translation is selected
        if ( jQuery( '#ezcoeditlanguages-existingts input[checked=checked]' ).length > 0 )
        {
            jQuery( '#ezcoeditlanguages-sourcets input[type=radio]' ).prop( 'disabled', true );
        }
    }
})( jQuery );
