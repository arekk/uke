Application.Listener.Subscribe('logs-new-loaded', function() {
  Application.Gmap.MapLoad('Application.Page.Logs.PickerMap');
});
Application.Listener.Subscribe('logs-create-loaded', function() {
  Application.Gmap.MapLoad('Application.Page.Logs.PickerMap');
});

Application.Page.Logs = {};
Application.Page.Logs.PickerMap = function() {
  var pos = new google.maps.LatLng(52.247686, 19.371425);
  var mapOptions = {
    zoom: 6,
    center: pos
  };
  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  var marker = new google.maps.Marker({
    position: pos,
    map: map,
    draggable:true,
    title: 'Ustaw mnie w miejscu, w którym prowadzisz nasłuch'
  });
  var geocoder = new google.maps.Geocoder();

  google.maps.event.addListener(marker, 'dragend', function(evt) {
    geocoder.geocode( { 'latLng': evt.latLng}, function(results, status) {
      $('#log_lat').val( evt.latLng.lat().toFixed(6));
      $('#log_lon').val( evt.latLng.lng().toFixed(6));
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
});
};