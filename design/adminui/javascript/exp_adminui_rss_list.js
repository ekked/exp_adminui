/**
 * Exponential Admin UI: the RSS lists (rss/list.tpl): a click anywhere in a sortable column heading sorts by it,
 * Enter and Space on the focused heading too. Printed after the tables.
 */
( function () {
    var headings = document.getElementsByTagName( 'th' ), i;

    for ( i = 0; i < headings.length; i++ )
    {
        if ( headings[i].className.indexOf( 'sortable' ) === -1 )
            continue;

        ( function ( heading ) {
            var links = heading.getElementsByTagName( 'a' );
            if ( !links.length )
                return;

            var href = links[0].href;

            heading.onclick = function ( event ) {
                // The link itself is left to the browser, so a middle click or
                // a modifier still opens a new tab the way it should.
                var target = ( event && event.target ) || window.event.srcElement;
                while ( target && target !== heading )
                {
                    if ( target.tagName && target.tagName.toLowerCase() === 'a' )
                        return true;
                    target = target.parentNode;
                }
                if ( event && ( event.metaKey || event.ctrlKey || event.shiftKey || event.button > 0 ) )
                    return true;

                window.location.href = href;
                return false;
            };

            heading.setAttribute( 'tabindex', '0' );
            heading.onkeydown = function ( event ) {
                var key = ( event || window.event ).keyCode;
                if ( key !== 13 && key !== 32 )
                    return true;
                window.location.href = href;
                return false;
            };
        } )( headings[i] );
    }
} )();
