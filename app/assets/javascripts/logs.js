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
  var func_on_geocode = function(lat, lon, country, level_1, level_2, level_3, address) {
    $('#log_lat').val(lat);
    $('#log_lon').val(lon);
    $('#log_country').val(country);
    $('#log_administrative_area_level_1').val(level_1);
    $('#log_administrative_area_level_2').val(level_2);
    $('#log_administrative_area_level_3').val(level_3);
    $('#log_street_address').val(address);
  };
  Application.Gmap.PickerMap($('#log_lat').val(), $('#log_lon').val(), func_on_geocode);
};
