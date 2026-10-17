/**
 * Exponential Admin UI: the extensions page (setup/extensions.tpl): the Update button is marked on changes, the info
 * cards open and close, the filter narrows the rows, and the loading order is changed by drag and drop or the
 * arrows and saved on every change (the texts and addresses are data-* attributes of #extension-order).
 */
$(document).ready(function() {
    var initialExtensionSettings = {};
    var extensionChecks = jQuery('[name=extensionform] :checkbox');

    // Highlight "Update" button on changes
    function styleUpdateButton() {
        var b = jQuery('[name=ActivateExtensionsButton]:first');
        jQuery(extensionChecks).each( function(){
            if (initialExtensionSettings[this.value] !== this.checked) {
                b.removeClass('button').addClass('defaultbutton');
                return false;
            } else {
                b.removeClass('defaultbutton').addClass('button');
            }
        });
    }

    jQuery(extensionChecks).each( function(){
        initialExtensionSettings[this.value] = this.checked;
    }).on('change', function(){styleUpdateButton();});

    // Extension info card popin
    function toggleExtensionCard( name ) {
        var row = jQuery( document.getElementById( 'extension-card-' + name ) );
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

    // Filter the rows of this page as you type.
    jQuery( '#extensions-filter-input' ).on( 'input', function() {
        var q = String( ( this.value ) ?? '' ).trim().toLowerCase();
        jQuery( '.extensions-list tr.extension-row' ).each( function() {
            var match = q === '' || jQuery( this ).text().toLowerCase().indexOf( q ) !== -1;
            jQuery( this ).toggle( match );
            if ( !match ) jQuery( document.getElementById( 'extension-card-' + jQuery( this ).data( 'name' ) ) ).hide();
        });
    });

    // The loading order: drag and drop (or the arrows), saved on every change.
    // Shown or hidden: remembered as a user preference, so the card opens
    // the way it was left, on any browser.
    var card = document.getElementById( 'extension-order-card' );
    if ( card && card.getAttribute( 'data-preference-url' ) ) {
        card.addEventListener( 'toggle', function() {
            var meta = document.querySelector( 'meta[name="csrf-token"]' );
            var field = document.querySelector( 'input[name="ezxform_token"]' );
            var request = new XMLHttpRequest();
            request.open( 'POST', card.getAttribute( 'data-preference-url' ) + '/' + ( card.open ? '1' : '0' ), true );
            request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8' );
            request.setRequestHeader( 'X-Requested-With', 'XMLHttpRequest' );
            if ( meta ) request.setRequestHeader( 'X-CSRF-Token', meta.getAttribute( 'content' ) );
            request.send( field ? 'ezxform_token=' + encodeURIComponent( field.value ) : '' );
        });
    }

    var list = document.getElementById( 'extension-order' );
    if ( !list ) return;
    var status = document.getElementById( 'extension-order-status' );
    var csrfMeta = document.querySelector( 'meta[name="csrf-token"]' );
    var tokenField = document.querySelector( 'input[name="ezxform_token"]' );
    var dragged = null, before = null, saving = false, pending = false;

    function items() { return Array.prototype.slice.call( list.querySelectorAll( '.extension-order-item' ) ); }
    function order() { return items().map( function( li ) { return li.getAttribute( 'data-name' ); } ); }

    function say( text, kind ) {
        status.textContent = text || '';
        status.className = 'extension-order-status' + ( kind ? ' is-' + kind : '' );
    }

    // Numbers in the list, the table and the info cards follow the list.
    function renumber() {
        items().forEach( function( li, i ) {
            li.querySelector( '.extension-order-position' ).textContent = i + 1;
            var cells = document.querySelectorAll( '[data-position-of]' );
            for ( var c = 0; c < cells.length; c++ )
                if ( cells[c].getAttribute( 'data-position-of' ) === li.getAttribute( 'data-name' ) )
                    cells[c].textContent = i + 1;
        });
    }

    // Puts the list into the order the server holds (after a refused save).
    function restore( names ) {
        var byName = {};
        items().forEach( function( li ) { byName[li.getAttribute( 'data-name' )] = li; } );
        names.forEach( function( name ) { if ( byName[name] ) list.appendChild( byName[name] ); } );
        renumber();
    }

    function save() {
        if ( saving ) { pending = true; return; }
        saving = true; pending = false;
        list.classList.add( 'is-saving' );
        say( list.getAttribute( 'data-saving' ), 'busy' );
        var body = 'ReorderExtensions=1';
        order().forEach( function( name ) { body += '&ExtensionOrder%5B%5D=' + encodeURIComponent( name ); } );
        if ( tokenField ) body += '&ezxform_token=' + encodeURIComponent( tokenField.value );
        var request = new XMLHttpRequest();
        request.open( 'POST', list.getAttribute( 'data-url' ), true );
        request.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8' );
        request.setRequestHeader( 'X-Requested-With', 'XMLHttpRequest' );
        if ( csrfMeta ) request.setRequestHeader( 'X-CSRF-Token', csrfMeta.getAttribute( 'content' ) );
        request.onload = function() {
            var data = null;
            try { data = JSON.parse( request.responseText ); } catch ( e ) {}
            saving = false;
            list.classList.remove( 'is-saving' );
            if ( data && data.ok ) {
                say( data.message, 'ok' );
                if ( pending ) save();
            } else {
                pending = false;
                if ( data && data.order ) restore( data.order );
                say( ( data && data.error ) || list.getAttribute( 'data-failed' ) + ' (HTTP ' + request.status + ')', 'error' );
            }
        };
        request.onerror = function() {
            saving = false; pending = false;
            list.classList.remove( 'is-saving' );
            say( list.getAttribute( 'data-failed' ), 'error' );
        };
        request.send( body );
    }

    // The list moves while dragging, so what you see is where it lands.
    list.addEventListener( 'dragstart', function( e ) {
        var li = e.target.closest ? e.target.closest( '.extension-order-item' ) : null;
        if ( !li ) return;
        dragged = li;
        before = order().join( ',' );
        e.dataTransfer.effectAllowed = 'move';
        try { e.dataTransfer.setData( 'text/plain', li.getAttribute( 'data-name' ) ); } catch ( err ) {}
        setTimeout( function() { li.classList.add( 'is-dragging' ); }, 0 );
    });
    list.addEventListener( 'dragover', function( e ) {
        if ( !dragged ) return;
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
        var over = e.target.closest ? e.target.closest( '.extension-order-item' ) : null;
        if ( !over || over === dragged ) return;
        var box = over.getBoundingClientRect();
        var after = ( e.clientY - box.top ) > box.height / 2;
        list.insertBefore( dragged, after ? over.nextSibling : over );
    });
    list.addEventListener( 'drop', function( e ) { if ( dragged ) e.preventDefault(); } );
    list.addEventListener( 'dragend', function() {
        if ( !dragged ) return;
        dragged.classList.remove( 'is-dragging' );
        dragged = null;
        renumber();
        if ( order().join( ',' ) !== before ) save();
    });

    // The arrows, for the keyboard and for touch screens.
    list.addEventListener( 'click', function( e ) {
        var button = e.target.closest ? e.target.closest( 'button' ) : null;
        if ( !button ) return;
        var li = button.closest( '.extension-order-item' );
        if ( button.classList.contains( 'extension-order-up' ) && li.previousElementSibling )
            list.insertBefore( li, li.previousElementSibling );
        else if ( button.classList.contains( 'extension-order-down' ) && li.nextElementSibling )
            list.insertBefore( li.nextElementSibling, li );
        else
            return;
        button.focus();
        renumber();
        save();
    });
});
