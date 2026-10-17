/**
 * Exponential Admin UI: the find box of the RAD page (setup/rad.tpl): every word typed has to match a card;
 * empty groups are hidden, Esc clears. Printed after the cards.
 */
( function () {
    var bar   = document.getElementById( 'radFind' ),
        input = document.getElementById( 'radFindInput' ),
        clear = document.getElementById( 'radFindClear' ),
        count = document.getElementById( 'radFindCount' ),
        none  = document.getElementById( 'radFindNone' );

    if ( !bar || !input ) return;

    // Collect the cards, and the text of each one, once. Reading textContent
    // per keystroke on sixty cards is wasteful and it never changes.
    // Whole class name only. rad-point-head and rad-point-what are children of
    // a card, and matching on a prefix would pick those up and hide the inside
    // of every card rather than the card.
    function hasClass( node, wanted )
    {
        return ( ' ' + ( node.className || '' ) + ' ' ).indexOf( ' ' + wanted + ' ' ) !== -1;
    }

    var cards = [], groups = [], i, all = document.getElementsByTagName( 'div' );

    for ( i = 0; i < all.length; i++ )
    {
        if ( hasClass( all[i], 'rad-point' ) )
            cards.push( { node: all[i], text: ( all[i].textContent || all[i].innerText || '' ).toLowerCase() } );
        else if ( hasClass( all[i], 'rad-group' ) )
            groups.push( all[i] );
    }

    if ( !cards.length ) return;

    // Only shown once it is known to work, so a browser that got this far is
    // the only one offered a box that does something.
    bar.hidden = false;

    function show( node, on )
    {
        var name = ( node.className || '' ).replace( / ?\bis-hidden\b/, '' );
        node.className = on ? name : name + ' is-hidden';
    }

    // Every word has to match, in any order and anywhere in the card. That is
    // what lets "cluster handler" and "handler cluster" both find the same
    // thing, which is how people actually type.
    function matches( text, words )
    {
        for ( var w = 0; w < words.length; w++ )
            if ( text.indexOf( words[w] ) === -1 )
                return false;

        return true;
    }

    function run()
    {
        var query = input.value.toLowerCase().replace( /^\s+|\s+$/g, '' ),
            words = query === '' ? [] : query.split( /\s+/ ),
            shown = 0, c, g;

        for ( c = 0; c < cards.length; c++ )
        {
            var on = words.length === 0 || matches( cards[c].text, words );
            show( cards[c].node, on );
            if ( on ) shown++;
        }

        // A group with nothing left in it goes too, or the page is a list of
        // headings with nothing under them.
        for ( g = 0; g < groups.length; g++ )
        {
            var points = groups[g].getElementsByTagName( 'div' ), any = false, p;

            for ( p = 0; p < points.length; p++ )
                if ( hasClass( points[p], 'rad-point' ) && !hasClass( points[p], 'is-hidden' ) )
                {
                    any = true;
                    break;
                }

            show( groups[g], any );
        }

        count.innerHTML = words.length === 0
                          ? ''
                          : shown + ' of ' + cards.length;

        if ( none ) none.hidden = !( words.length && shown === 0 );
    }

    input.onkeyup = run;
    input.onsearch = run;

    if ( clear )
        clear.onclick = function () { input.value = ''; run(); input.focus(); return false; };

    // Esc clears rather than leaving somebody with a filtered page and no
    // obvious way back to all of it.
    input.onkeydown = function ( event ) {
        if ( ( event || window.event ).keyCode === 27 ) { input.value = ''; run(); }
    };

    run();
} )();
