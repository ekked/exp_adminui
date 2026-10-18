/**
 * Exponential Admin UI: the map picker of the ezgmaplocation edit template (content/datatype/edit/ezgmaplocation.tpl).
 *
 * The map element carries its settings: <div id="ezgml-map-<attribute id>" data-expui-gml="<attribute id>"
 * data-expui-gml-base="<lat/long id base>" data-expui-gml-not-found="..." data-expui-gml-location-error="...">.
 * Every such map is set up once, on window load (after the Google Maps API script), as before.
 * eZGmapLocation_MapControl( attributeId, latLongAttributeBase ) stays a global function.
 */
(function ()
{
    if ( window.expAdminUIGmapLocation )
        return;
    window.expAdminUIGmapLocation = true;

    function message( attributeId, name )
    {
        var map = document.getElementById( 'ezgml-map-' + attributeId );
        return ( map && map.getAttribute( 'data-expui-gml-' + name ) ) || '';
    }

    window.eZGmapLocation_MapControl = function ( attributeId, latLongAttributeBase )
    {
        var mapid = 'ezgml-map-' + attributeId;
        var latid  = 'ezcoa-' + latLongAttributeBase + '_latitude';
        var longid = 'ezcoa-' + latLongAttributeBase + '_longitude';
        var geocoder = null;
        var addressid = 'ezgml-address-' + attributeId;
        var zoommax = 13;

        var showAddress = function()
        {
            var address = document.getElementById( addressid ).value;
            if ( geocoder )
            {
                geocoder.geocode( {'address' : address}, function( results, status )
                {
                    if ( status == google.maps.GeocoderStatus.OK )
                    {
                        map.setOptions( { center: results[0].geometry.location, zoom : zoommax } );
                                            marker.setPosition(  results[0].geometry.location );
                        updateLatLngFields( results[0].geometry.location );
                    }
                    else
                    {
                         alert( message( attributeId, 'not-found' ).replace( '%address', address ) );
                    }
                });
            }
        };

        var updateLatLngFields = function( point )
        {
            document.getElementById(latid).value = point.lat();
            document.getElementById(longid).value = point.lng();
            document.getElementById( 'ezgml-restore-button-' + attributeId ).disabled = false;
        };

        var restoretLatLngFields = function()
        {
            document.getElementById( latid ).value     = document.getElementById('ezgml_hidden_latitude_' + attributeId ).value;
            document.getElementById( longid ).value    = document.getElementById('ezgml_hidden_longitude_' + attributeId ).value;
            document.getElementById( addressid ).value = document.getElementById('ezgml_hidden_address_' + attributeId ).value;
            if ( document.getElementById( latid ).value && document.getElementById( latid ).value != 0 )
            {
                var point = new google.maps.LatLng( document.getElementById( latid ).value, document.getElementById( longid ).value );
                //map.setCenter(point, 13);
                marker.setPosition( point );
                map.panTo( point );
            }
            document.getElementById( 'ezgml-restore-button-' + attributeId ).disabled = true;
            return false;
        };

        var getUserPosition = function()
        {
            navigator.geolocation.getCurrentPosition( function( position )
            {
                var location = '';
                var point = new google.maps.LatLng( position.coords.latitude, position.coords.longitude );

                if ( navigator.geolocation.type == 'Gears' && position.gearsAddress )
                    location = [position.gearsAddress.city, position.gearsAddress.region, position.gearsAddress.country].join(', ');
                else if ( navigator.geolocation.type == 'ClientLocation' )
                    location = [position.address.city, position.address.region, position.address.country].join(', ');

                document.getElementById( addressid ).value = location;
                map.setOptions( {zoom: zoommax, center: point} );
                marker.setPosition( point );
                updateLatLngFields( point );
            },
            function( e )
            {
                alert( message( attributeId, 'location-error' ).replace( '%error', e.message ) );
            },
            { 'gearsRequestAddress': true });
        };

            var startPoint = null;
            var zoom = 0;
            var map = null;
            var marker = null;

        if ( document.getElementById( latid ).value && document.getElementById( latid ).value != 0 )
        {
            startPoint = new google.maps.LatLng( document.getElementById( latid ).value, document.getElementById( longid ).value );
            zoom = zoommax;
        }
        else
        {
            startPoint = new google.maps.LatLng( 0, 0 );
        }

        var mWrapper = document.getElementById(mapid),
            initializeWhenVisible = function(callback)
            {
                    callback = callback || function(){};
                    var i = 1,int = setInterval(function() {
                        (i++ && !isVisible(mWrapper)) || (clearInterval(int), callback());
                    }, 100);
            },
            isVisible = function(elem)
            {
                return (elem.offsetWidth || elem.offsetHeight);
            },
            initMap = function()
            {
                map = new google.maps.Map( document.getElementById( mapid ), { center: startPoint, zoom : zoom, mapTypeId: google.maps.MapTypeId.ROADMAP } );
                marker = new google.maps.Marker({ map: map, position: startPoint, draggable: true });
                google.maps.event.addListener( marker, 'dragend', function( event ){
                    updateLatLngFields( event.latLng );
                        document.getElementById( addressid ).value = '';
                })

                geocoder = new google.maps.Geocoder();
                google.maps.event.addListener( map, 'click', function( event )
                {
                        marker.setPosition( event.latLng );
                        map.panTo( event.latLng );
                        updateLatLngFields( event.latLng );
                        document.getElementById( addressid ).value = '';
                });
            };

        initializeWhenVisible(initMap);

        document.getElementById( 'ezgml-address-button-' + attributeId ).onclick = showAddress;
        document.getElementById( 'ezgml-restore-button-' + attributeId ).onclick = restoretLatLngFields;

        if ( navigator.geolocation )
        {
            document.getElementById( 'ezgml-mylocation-button-' + attributeId ).onclick = getUserPosition;
            document.getElementById( 'ezgml-mylocation-button-' + attributeId ).disabled = false;
        }

    };

    function setUp()
    {
        // the map API did not load (no API key, blocked, offline): the coordinates are entered by hand
        if ( typeof google === 'undefined' || !google.maps )
            return;
        var maps = document.querySelectorAll( '[data-expui-gml]' );
        for ( var i = 0; i < maps.length; i++ )
        {
            if ( maps[i].getAttribute( 'data-expui-gml-ready' ) )
                continue;
            maps[i].setAttribute( 'data-expui-gml-ready', '1' );
            window.eZGmapLocation_MapControl( maps[i].getAttribute( 'data-expui-gml' ), maps[i].getAttribute( 'data-expui-gml-base' ) );
        }
    }

    if ( document.readyState === 'complete' )
        setUp();
    else
        window.addEventListener( 'load', setUp, false );
})();
