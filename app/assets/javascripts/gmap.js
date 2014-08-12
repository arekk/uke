Application.Gmap = {};
Application.Gmap.MapJsLoaded = false;
Application.Gmap.MapLoad = function(callback) {
  if (Application.Gmap.MapJsLoaded) {
    return;
  }
  Application.Log('Loading map for callback ' + callback);

  var url = 'https://maps.googleapis.com/maps/api/js?key=' + Application.Options.Get('GoogleMapsApiKey');
  if (callback) {
    url = url + '&callback=' + callback;
  }
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src =  url;
  document.body.appendChild(script);

  Application.Gmap.MapJsLoaded = true;
};

Application.Gmap.GeocodeByAddr = function(addr, on_geocode) {
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { 'address': addr}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      on_geocode(results[0].geometry.location);
    }
    else {
      on_geocode();
      Application.Log("Geocode was not successful for the following reason: " + status);
    }
  });
};

Application.Gmap.GeocodeByCoords = function(lat_lng, on_geocode) {
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { 'latLng': lat_lng}, function(results, status) {
    var lat, lon, country, level_1, level_2, level_3, address = null;

    lat = lat_lng.lat().toFixed(6);
    lon = lat_lng.lng().toFixed(6);

    if (status == google.maps.GeocoderStatus.OK) {
      // Pierwsze potrzebuję kraj, po to, aby usunąć go ze wszystkich pozostałych elementów
      jQuery.each(results, function(pos, elem){
        if (elem.types[0] == 'country') {
          country = elem.formatted_address;
        }
      });
      jQuery.each(results, function(pos, elem){
        if (elem.types[0] == 'administrative_area_level_1') {
          level_1 = elem.formatted_address.replace(country, '').replace('Województwo', '').replace(',', '').trim();
        }
        if (elem.types[0] == 'administrative_area_level_2') {
          level_2 = elem.formatted_address.replace(country, '').replace(',', '').trim();
        }
        if (elem.types[0] == 'administrative_area_level_3') {
          level_3 = elem.formatted_address.replace(country, '').replace(',', '').trim();
        }
        if (elem.types[0] == 'street_address') {
          address = elem.formatted_address;
        }
      });
      on_geocode(lat, lon, country, level_1, level_2, level_3, address);
    } else {
      on_geocode();
      Application.Log("Geocode was not successful for the following reason: " + status);
    }
  });
};

Application.Gmap.PickerMap = function(lat, lon, on_geocode) {
  var mapOptions, pos;
  if (lat && lon) {
    pos = new google.maps.LatLng(lat, lon);
    mapOptions = {zoom: 12, center: pos};
  } else {
    pos = new google.maps.LatLng(52.247686, 19.371425);
    mapOptions = {zoom: 6, center: pos};
  }

  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  var marker = new google.maps.Marker({
    position: pos,
    map: map,
    draggable:true,
    animation: google.maps.Animation.DROP,
    title: 'Ustaw mnie w miejscu, w którym prowadzisz nasłuch'
  });

  google.maps.event.addListener(marker, 'dragend', function(evt) {
    Application.Gmap.GeocodeByCoords(evt.latLng, on_geocode);
  });
};
