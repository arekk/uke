Application.Listener.Subscribe('log-entries-new-loaded',    function() { Application.Gmap.MapLoad('Application.Page.LogEntries.Run'); });
Application.Listener.Subscribe('log-entries-create-loaded', function() { Application.Gmap.MapLoad('Application.Page.LogEntries.Run'); });

Application.Page.LogEntries = {};
Application.Page.LogEntries.Run = function() 
{
  $('#log-entry-mhz-search-button').click(function(){
    location.href = Application.Options.Get('NewLogEntryPath') + '?mhz=' + $('#log_entry_mhz').val();
  });
  
  var func_on_geocode = function(lat, lon, country, level_1, level_2, level_3, address) {
    $('#log_entry_lat').val(lat);
    $('#log_entry_lon').val(lon);
    $('#log_entry_country').val(country);
    $('#log_entry_administrative_area_level_1').val(level_1);
    $('#log_entry_administrative_area_level_2').val(level_2);
    $('#log_entry_administrative_area_level_3').val(level_3);
    $('#log_entry_street_address').val(address);
  };
  var func_on_geocode_from_log = function() {
    var log_location = Application.Options.Get('LogLocation');
    var addr = log_location.administrative_area_level_2 + ', ' + log_location.administrative_area_level_1 + ', ' + log_location.country;
    
    Application.Gmap.GeocodeByAddr(addr, function(lat_lng) {
      if ($('#map-canvas').length > 0) {
        Application.Gmap.PickerMap(lat_lng.lat(), lat_lng.lng(), func_on_geocode);
      }
      $('#log_entry_lat').val(lat_lng.lat());
      $('#log_entry_lon').val(lat_lng.lng());
      $('#log_entry_country').val(log_location.country);
      $('#log_entry_administrative_area_level_1').val(log_location.administrative_area_level_1);
      $('#log_entry_administrative_area_level_2').val(log_location.administrative_area_level_2);
      $('#log_entry_administrative_area_level_3').val('');
      $('#log_entry_street_address').val('');
    });
  }
  
  $('*[data-geocode="true"]').change(function() {
    Application.Gmap.GeocodeByCoords(new google.maps.LatLng($(this).attr('data-lat'), $(this).attr('data-lon')), func_on_geocode);
  });
  $('*[data-geocode-from-log="true"]').change(func_on_geocode_from_log);

  if ($('#map-canvas').length > 0 && $('#log_entry_lat').val() && $('#log_entry_lon').val()) {
    Application.Gmap.PickerMap($('#log_entry_lat').val(), $('#log_entry_lon').val(), func_on_geocode);
  }
  else {
    func_on_geocode_from_log();
  }
  
};
