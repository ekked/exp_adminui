/**
 * Exponential Admin UI: the xrowmetadata edit template: the "more" checkbox shows and hides the other options.
 */
jQuery(document).ready(function() {
    jQuery('#more_checkbox').on('click', function() {
        jQuery('#options_div').toggle();
    });

});
