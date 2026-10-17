/**
 * Exponential Admin UI: the class edit page (class/edit.tpl). The attribute last changed is scrolled to and focused;
 * the move buttons move an attribute in place and store the move on the server (a move the server did not store is
 * put back). The text of a failed move is the data-move-failed attribute of #ezcca-edit-list.
 * "Add attribute" at the top disables the datatype list at the bottom: data-expui-disable-on-click.
 */
jQuery(function( $ )//called on document.ready
{
    // .length, not .size(): jQuery 3 removed .size(), and the call threw
    // before the move buttons below were set up, so every click posted the
    // whole form and reloaded the page (with an older jQuery it worked).
    var el = $('#LastChangedID input[name^=ContentAttribute_name]');
    if ( el.length ) {
        window.scrollTo(0, Math.max( el.offset().top - 180, 0 ));
        el.trigger( 'focus' );
    }

    var list = $('#ezcca-edit-list');
    var status = $('<p class="ezcca-move-status" role="status" aria-live="polite"></p>').insertBefore( list ).data( 'failed', list.attr( 'data-move-failed' ) );

    // The numbers in front of the names and the row colours follow the rows.
    function renumberAttributes()
    {
        list.children('tbody').children('tr.ezcca-edit-list-item').each( function( i )
        {
            var th = $(this).find('> td > table > tbody > tr > th.wide, > td > table > tr > th.wide').first();
            th.html( th.html().replace( /^\s*\d+\./, ( i + 1 ) + '.' ) );
            $(this).removeClass( 'bglight bgdark' ).addClass( i % 2 ? 'bgdark' : 'bglight' );
        });
    }

    function buttons( on )
    {
        list.find('.listbutton [name^=Move]').prop( 'disabled', !on ).toggleClass( 'disabled', !on );
    }

    // Move up, down, to the top or to the bottom, in place; the server
    // stores it, and a move it did not store is put back, so the page never
    // shows an order that is not saved. The priority fields follow the rows,
    // so Apply and OK store the order shown.
    function rows()
    {
        return list.children('tbody').children('tr.ezcca-edit-list-item');
    }
    function priorities()
    {
        rows().each( function( i ) { $(this).find('input[name^=ContentAttribute_priority]').val( ( i + 1 ) * 10 ); } );
    }
    list.find('.listbutton [name^=Move]').on('click', function( e )
    {
        e.preventDefault();
        var tr = $(this).closest('tr.ezcca-edit-list-item'), param = this.name.split('_'), action = param[0];
        var all = rows(), from = all.index( tr ), last = all.length - 1;
        var to = { MoveUp: from - 1, MoveDown: from + 1, MoveTop: 0, MoveBottom: last }[ action ];
        if ( to === undefined || to < 0 || to > last || to === from )
            return false;
        buttons( false );
        var place = function( index )
        {
            var others = rows().not( tr );
            if ( index >= others.length ) others.last().after( tr ); else others.eq( index ).before( tr );
            renumberAttributes();
            priorities();
        };
        place( to );

        var postVar = { 'ContentClassHasInput': 0 }, _tokenNode = document.getElementById('ezxform_token_js');
        var meta = document.querySelector('meta[name="csrf-token"]');
        postVar[ action ] = param[1];
        if ( _tokenNode ) postVar['ezxform_token'] = _tokenNode.getAttribute('title');
        $.ajax({
            type: 'POST',
            url: $('#ClassEdit').attr('action'),
            data: postVar,
            headers: meta ? { 'X-CSRF-Token': meta.getAttribute('content') } : {}
        }).done( function( data, text, xhr )
        {
            // Only a server that stored the move says so; anything else (an
            // ordinary page) means it did not.
            if ( xhr.getResponseHeader( 'X-Class-Attribute-Moved' ) !== '1' )
            {
                place( from );
                status.text( status.data( 'failed' ) ).addClass( 'is-error text-danger' );
                return;
            }
            status.text( '' ).removeClass( 'is-error text-danger' );
        }).fail( function( xhr )
        {
            place( from );
            status.text( status.data( 'failed' ) + ' (HTTP ' + xhr.status + ')' ).addClass( 'is-error text-danger' );
        }).always( function()
        {
            buttons( true );
        });
        return false;
    });

});
