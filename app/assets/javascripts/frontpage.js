Application.Listener.Subscribe('frontpage-index-loaded', function() {
  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    if ($(this).attr('href') == '#map') {
      Application.Gmap.MapLoad('Application.Page.Frontpage.MapInit');
    }
  });
});

Application.Page.Frontpage = {};

Application.Page.Frontpage.MapInit = function() {
  var markers = Application.Options.Get('MapMarkers');

  var mapOptions = {
    zoom: 10,
    center: new google.maps.LatLng(markers[0].lat, markers[0].lng)
  };

  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

  var pins = {
    voice: new google.maps.MarkerImage('http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=g|5cb85c',
        new google.maps.Size(21, 34),
        new google.maps.Point(0,0),
        new google.maps.Point(10, 34)),
    digital: new google.maps.MarkerImage('http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=d|428bca',
        new google.maps.Size(21, 34),
        new google.maps.Point(0,0),
        new google.maps.Point(10, 34))
  };

  var info_window = new google.maps.InfoWindow();
  var range_circle = new google.maps.Circle({
        strokeWeight: 0,
        fillColor: '#FF0000',
        fillOpacity: 0.35,
        map: map
      });

  $.each(Application.Options.Get('MapMarkers'), function(index, value) {
    var myLatlng = new google.maps.LatLng(value.lat, value.lng);
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        icon: pins[value.type]
    });

    google.maps.event.addListener(marker, 'click', function() {
      info_window.close();
      info_window.setContent(value.title);
      info_window.open(map, marker);
      range_circle.setCenter(marker.getPosition());
      range_circle.setRadius(value.radius*1000);
    });
  })
};
