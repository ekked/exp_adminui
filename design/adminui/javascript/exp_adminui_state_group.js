/**
 * Exponential Admin UI: the states of a state group (state/group.tpl): the arrows move a state, the numbers
 * follow and the move is announced. The text is the data-expui-text attribute (JSON) of #state-list.
 */
var expStateOrderText = JSON.parse( ( document.getElementById( 'state-list' ) || document.documentElement ).getAttribute( 'data-expui-text' ) || '{}' );
(function () {
    var list = document.getElementById( 'state-list' );
    if ( !list ) return;
    var status = document.getElementById( 'state-order-status' );
    Array.prototype.forEach.call( document.querySelectorAll( '.a4-page .exp-js-only' ), function ( el ) { el.hidden = false; } );
    function renumber() {
        var items = list.querySelectorAll( '.a4-state-item' );
        Array.prototype.forEach.call( items, function ( item, i ) {
            item.querySelector( '.a4-state-order-input' ).value = i + 1;
            item.querySelector( '.a4-state-pos' ).textContent = i + 1;
            item.querySelector( '.exp-move-up' ).disabled = i === 0;
            item.querySelector( '.exp-move-down' ).disabled = i === items.length - 1;
        } );
    }
    list.addEventListener( 'click', function ( event ) {
        var button = event.target.closest( '.exp-move-up, .exp-move-down' );
        if ( !button ) return;
        var item = button.closest( '.a4-state-item' );
        var up = button.classList.contains( 'exp-move-up' );
        var other = up ? item.previousElementSibling : item.nextElementSibling;
        if ( !other ) return;
        list.insertBefore( item, up ? other : other.nextElementSibling );
        renumber();
        var target = item.querySelector( up ? '.exp-move-up' : '.exp-move-down' );
        ( target.disabled ? item.querySelector( up ? '.exp-move-down' : '.exp-move-up' ) : target ).focus();
        var position = Array.prototype.indexOf.call( list.children, item ) + 1;
        status.textContent = expStateOrderText.moved.replace( '%state', item.getAttribute( 'data-state-name' ) ).replace( '%position', position );
    } );
    renumber();
})();
