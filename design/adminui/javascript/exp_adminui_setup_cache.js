/**
 * Exponential Admin UI: the static cache run of the cache page (setup/cache.tpl), shown line by line as the server
 * writes it (EventSource), instead of posting the form and waiting for one long silent request. Without EventSource
 * the button stays an ordinary form submit. The stream address and the texts are data-expui-stream-url and
 * data-expui-text (JSON) of #staticcache-console. Printed after the console.
 */
(function ()
{
    var consoleEl = document.getElementById( 'staticcache-console' );
    var startBtn  = document.getElementById( 'staticcache-start' );
    var stopBtn   = document.getElementById( 'staticcache-stop' );
    var statusEl  = document.getElementById( 'staticcache-status' );
    var saEl      = document.getElementById( 'staticcache-siteaccess' );
    var source    = null;
    var lines     = 0;

    if ( !startBtn || !consoleEl || typeof window.EventSource === 'undefined' )
        return;

    var streamUrl = consoleEl.getAttribute( 'data-expui-stream-url' ) || '';
    var text = {};
    try { text = JSON.parse( consoleEl.getAttribute( 'data-expui-text' ) || '{}' ) || {}; } catch ( e ) { text = {}; }

    var colours = {
        phase:        '#7fd1ff',
        'phase-item': '#ffffff',
        ok:           '#9bdc7a',
        warn:         '#e8c765',
        error:        '#ff8a80',
        info:         '#9a9a9a',
        done:         '#7fd1ff'
    };

    function write( type, message )
    {
        var atBottom = consoleEl.scrollTop + consoleEl.clientHeight >= consoleEl.scrollHeight - 8;
        var line = document.createElement( 'div' );
        line.style.color = colours[type] || '#d8d8d8';
        if ( type === 'phase' || type === 'done' )
            line.style.fontWeight = 'bold';
        line.appendChild( document.createTextNode( message ) );
        consoleEl.appendChild( line );
        lines++;
        // Only follow the tail while the operator is already at the bottom.
        if ( atBottom )
            consoleEl.scrollTop = consoleEl.scrollHeight;
    }

    function finish( message )
    {
        if ( source ) { source.close(); source = null; }
        startBtn.disabled = false;
        stopBtn.disabled  = true;
        statusEl.innerHTML = '';
        statusEl.appendChild( document.createTextNode( message ) );
    }

    startBtn.onclick = function ( event )
    {
        if ( event && event.preventDefault ) event.preventDefault();
        if ( source ) return false;

        consoleEl.style.display = 'block';
        consoleEl.innerHTML = '';
        lines = 0;

        var pages = parseInt( document.getElementById( 'staticcache-max-pages' ).value, 10 );
        var depth = parseInt( document.getElementById( 'staticcache-max-depth' ).value, 10 );
        if ( isNaN( pages ) || pages < 1 ) pages = 2500;
        if ( isNaN( depth ) || depth < 0 ) depth = 12;

        var url = streamUrl + '?SiteAccess=' + encodeURIComponent( saEl ? saEl.value : '' )
                + '&MaxPages=' + pages + '&MaxDepth=' + depth;

        startBtn.disabled = true;
        stopBtn.disabled  = false;
        statusEl.innerHTML = '';
        statusEl.appendChild( document.createTextNode( text.running ) );

        source = new EventSource( url );

        source.onmessage = function ( messageEvent )
        {
            var payload;
            try { payload = JSON.parse( messageEvent.data ); }
            catch ( e ) { return; }
            write( payload.type, payload.message );
            if ( payload.type === 'done' )
                finish( text.finished );
        };

        source.addEventListener( 'end', function () { finish( text.finished ); } );

        source.onerror = function ()
        {
            // EventSource reconnects on its own, which would start the run again from the beginning; closing
            // here keeps one run to a press.
            if ( lines === 0 )
                write( 'error', text.noStream );
            else
                write( 'warn', text.closed );
            finish( text.stopped );
        };

        return false;
    };

    // Closing the stream is all the browser can do: the run is already under way on the server and the pages it
    // has written stay written.
    stopBtn.onclick = function ()
    {
        write( 'warn', text.stoppedByOperator );
        finish( text.stopped );
        return false;
    };
})();
