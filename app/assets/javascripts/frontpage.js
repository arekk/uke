Application.Listener.Subscribe('frontpage-index-loaded', function() {
  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    if ($(this).attr('href') == '#map') {
      Application.Gmap.MapLoad('Application.Page.Frontpage.MapInit');
    }
  });
});

Application.Page.Frontpage = {};
Application.Page.Frontpage.MapInfoWindow = null;
Application.Page.Frontpage.MapInit = function() {
  var lat_sum = 0, lat_num = 0, lng_sum = 0, lng_num = 0;

  $.each(Application.Options.Get('MapMarkers'), function(index, value) {
    lat_sum = lat_sum + parseFloat(value.lat);
    lng_sum = lng_sum + parseFloat(value.lng);
    lat_num = lat_num + 1;
    lng_num = lng_num + 1;
  });

  var mapOptions = {
    zoom: 10,
    center: new google.maps.LatLng(lat_sum/lat_num, lng_sum/lng_num)
  };

  var map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);

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

  $.each(Application.Options.Get('MapMarkers'), function(index, value) {
    var myLatlng = new google.maps.LatLng(value.lat, value.lng);
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        icon: pins[value.station_type]
    });

    var infowindow = new google.maps.InfoWindow({
      content: value.title
    });
    google.maps.event.addListener(marker, 'click', function() {
      if (Application.Page.Frontpage.MapInfoWindow) {
        Application.Page.Frontpage.MapInfoWindow.close();
      }
      Application.Page.Frontpage.MapInfoWindow = infowindow;
      
      infowindow.open(map, marker);
    });


  })
};
