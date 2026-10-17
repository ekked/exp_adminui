/**
 * Exponential Admin UI: the first step of a new policy (role/createpolicystep1.tpl): the function list follows the
 * module chosen, and the buttons that fit are enabled. The functions of each module (JSON) and the text "Every
 * function" are data-expui-functions and data-expui-every of #ezrole-createpolizy-module.
 */
jQuery(function( $ )
{
    var moduleSelect = document.getElementById( 'ezrole-createpolizy-module' );
    var moduleList = JSON.parse( moduleSelect.getAttribute( 'data-expui-functions' ) || '{}' ), everyFunction = moduleSelect.getAttribute( 'data-expui-every' ) || '';
    $('#ezrole-createpolizy-module').on('change', function(e)
    {
        if ( moduleList[ this.value ] && moduleList[ this.value ].length )
        {
        	setFunctionOptions( moduleList[ this.value ] );
        	$('#createpolicyform input.button-module').removeClass('button').addClass('button-disabled').prop('disabled', true);
        	$('#createpolicyform input.button-function').removeClass('button-disabled').addClass('button').prop('disabled', false);
        }
        else
        {
        	setFunctionOptions( [everyFunction], true );
        	$('#createpolicyform input.button-function').removeClass('button').addClass('button-disabled').prop('disabled', true);
        	$('#createpolicyform input.button-module').removeClass('button-disabled').addClass('button').prop('disabled', false)
        }
    });
    function setFunctionOptions( list, disable )
    {
        $('#ezrole-createpolizy-function').empty().append( jQuery.map( list, function( item, i )
        {
            return '<option value="' + item + '">' + item + '</option>';
        } ).join() ).prop( 'disabled', disable === true ).val( disable === true ? '*' : list[0] );

    }
});
