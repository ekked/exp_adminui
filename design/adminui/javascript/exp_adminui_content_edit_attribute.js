/**
 * Exponential Admin UI: the attribute groups of the content edit form (content/edit_attribute.tpl) fold and unfold;
 * a group is folded on load unless one of its attributes has an error (label.message-error).
 */
jQuery(function( $ )
{
    $('fieldset.ezcca-collapsible legend a').on( 'click', function()
    {
        var container = $( this.parentNode.parentNode ), inner = container.find('div.ezcca-collapsible-fieldset-content');
        if ( container.hasClass('ezcca-collapsed') )
        {
            container.removeClass('ezcca-collapsed');
            inner.slideDown( 150 );
        }
        else
        {
            inner.slideUp( 150, function(){
                $( this.parentNode ).addClass('ezcca-collapsed');
            });
        }
    });
    // Collapse by default, unless the group has at least one attribute with label.message-error
    $('fieldset.ezcca-collapsible').each( function(){
        if ( $(this).find('label.message-error').length == 0 )
        {
            $(this).addClass('ezcca-collapsed').find('div.ezcca-collapsible-fieldset-content').hide();
        }
    } );
});
