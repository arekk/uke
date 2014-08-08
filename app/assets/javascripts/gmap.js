Application.Gmap = {};
Application.Gmap.MapJsLoaded = false;
Application.Gmap.MapLoad = function(callback) {
  if (Application.Gmap.MapJsLoaded) {
    return;
  }

  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?key=' + Application.Options.Get('GoogleMapsApiKey') + '&' +
      'callback=' + callback;
  document.body.appendChild(script);

  Application.Gmap.MapJsLoaded = true;
};
