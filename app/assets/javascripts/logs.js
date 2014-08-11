Application.Listener.Subscribe('logs-new-loaded', function() {
  Application.Gmap.MapLoad('Application.Page.Logs.PickerMap');
});
Application.Listener.Subscribe('logs-create-loaded', function() {
  Application.Gmap.MapLoad('Application.Page.Logs.PickerMap');
});
Application.Listener.Subscribe('logs-edit-loaded', function() {
  Application.Gmap.MapLoad('Application.Page.Logs.PickerMap');
});
Application.Listener.Subscribe('logs-update-loaded', function() {
  Application.Gmap.MapLoad('Application.Page.Logs.PickerMap');
});

Application.Page.Logs = {};
Application.Page.Logs.PickerMap = function() {
  var mapOptions, pos;
  if ($('#log_lat').val() && $('#log_lon').val()) {
    pos = new google.maps.LatLng($('#log_lat').val(), $('#log_lon').val());
    mapOptions = {zoom: 14, center: pos};
  } else {
    pos = new google.maps.LatLng(52.247686, 19.371425);
    mapOptions = {zoom: 6, center: pos};
  }

  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  var marker = new google.maps.Marker({
    position: pos,
    map: map,
    draggable:true,
    title: 'Ustaw mnie w miejscu, w którym prowadzisz nasłuch'
  });


  var func_geocode = function(lat_lng) {
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode( { 'latLng': lat_lng}, function(results, status) {
      $('#log_lat').val( lat_lng.lat().toFixed(6));
      $('#log_lon').val( lat_lng.lng().toFixed(6));
      if (status == google.maps.GeocoderStatus.OK) {
        // Pierwsze potrzebuję kraj, po to, aby usunąć go ze wszystkich pozostałych elementów
        var country = '';
        jQuery.each(results, function(pos, elem){
          if (elem.types[0] == 'country') {
            country = elem.formatted_address;
            $('#log_country').val(country);
          }
        });
        jQuery.each(results, function(pos, elem){
          if (elem.types[0] == 'administrative_area_level_1') {
            $('#log_administrative_area_level_1').val(elem.formatted_address.replace(country, '').replace('Województwo', '').replace(',', '').trim());
          }
          if (elem.types[0] == 'administrative_area_level_2') {
            $('#log_administrative_area_level_2').val(elem.formatted_address.replace(country, '').replace(',', '').trim());
          }
          if (elem.types[0] == 'administrative_area_level_3') {
            $('#log_administrative_area_level_3').val(elem.formatted_address.replace(country, '').replace(',', '').trim());
          }
          if (elem.types[0] == 'street_address') {
            $('#log_street_address').val(elem.formatted_address);
          }
        });
      } else {
        Application.Log("Geocode was not successful for the following reason: " + status);
      }
    });
  };

  google.maps.event.addListener(marker, 'dragend', function(evt) {
    func_geocode(evt.latLng);
  });
};
