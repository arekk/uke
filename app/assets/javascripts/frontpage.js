Application.Listener.Subscribe('frontpage-index-loaded', function() {
  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    if ($(this).attr('href') == '#map') {
      Application.Page.Frontpage.MapLoad();
    }
  });
});

Application.Page.Frontpage = {};

Application.Page.Frontpage.MapJsLoaded = false;
Application.Page.Frontpage.MapLoad = function() {
  if (Application.Page.Frontpage.MapJsLoaded) {
    return;
  }

  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?key=' + Application.Options.Get('GoogleMapsApiKey') + '&' +
      'callback=Application.Page.Frontpage.MapInit';
  document.body.appendChild(script);

  Application.Page.Frontpage.MapJsLoaded = true;
};

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

  $.each(Application.Options.Get('MapMarkers'), function(index, value) {
    var myLatlng = new google.maps.LatLng(value.lat, value.lng);
    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map
    });
    var infowindow = new google.maps.InfoWindow({
      content: value.title
    });
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });
  })
};
