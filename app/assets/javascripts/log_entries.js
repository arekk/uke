Application.Listener.Subscribe('log-entries-new-loaded',    function() { Application.Gmap.MapLoad('Application.Page.LogEntries.Run'); });
Application.Listener.Subscribe('log-entries-create-loaded', function() { Application.Gmap.MapLoad('Application.Page.LogEntries.Run'); });

Application.Page.LogEntries = {};
Application.Page.LogEntries.Run = function()
{
  var func_on_geocode = function(lat, lon, country, level_1, level_2, level_3, address) {
    $('#log_entry_lat').val(lat);
    $('#log_entry_lon').val(lon);
    $('#log_entry_country').val(country);
    $('#log_entry_administrative_area_level_1').val(level_1);
    $('#log_entry_administrative_area_level_2').val(level_2);
    $('#log_entry_administrative_area_level_3').val(level_3);
    $('#log_entry_street_address').val(address);
  };

  var func_on_geocode_from_log = function(on_geocoded) {
    var log_location = Application.Options.Get('LogLocation');
    var addr = log_location.administrative_area_level_2 + ', ' + log_location.administrative_area_level_1 + ', ' + log_location.country;
    Application.Gmap.GeocodeByAddr(addr, function(lat_lng) {
      $('#log_entry_lat').val(lat_lng.lat());
      $('#log_entry_lon').val(lat_lng.lng());
      $('#log_entry_country').val(log_location.country);
      $('#log_entry_administrative_area_level_1').val(log_location.administrative_area_level_1);
      $('#log_entry_administrative_area_level_2').val(log_location.administrative_area_level_2);
      $('#log_entry_administrative_area_level_3').val('');
      $('#log_entry_street_address').val('');
      if (on_geocoded) {
        on_geocoded(lat_lng);
      }
    });
  };

  var func_uncheck_uke_station = function() {
    $('.uke-station-radio').each(function(i, elem) {
      $(elem).removeAttr('checked');
    });
  };

  $('#log-entry-mhz-search-button').click(function(){
    location.href = Application.Options.Get('NewLogEntryPath') + '?mhz=' + $('#log_entry_mhz').val();
  });

  $('*[data-geocode="true"]').change(function() {
    Application.Gmap.GeocodeByCoords(new google.maps.LatLng($(this).attr('data-lat'), $(this).attr('data-lon')), func_on_geocode);
  });

  $('#accordion').on('shown.bs.collapse', function (a) {
    var tab_id = $(a.target).attr('id');
    var selected_panel = $('#log_entry_selected_panel');

    $('*[data-panel-check="true"]').each(function(i, elem) {
      $(elem).addClass('hidden');
      if ($(elem).attr('data-panel') == tab_id) {
        $(elem).removeClass('hidden');
      }
    });

    if (tab_id == 'collapse-dont-know') {
      func_uncheck_uke_station();
      func_on_geocode();
    }
    if (tab_id == 'collapse-uke-list') {
      if (selected_panel.val() != tab_id) {
        func_on_geocode();
      }
    }
    if (tab_id == 'collapse-map') {
      func_uncheck_uke_station();
      func_on_geocode_from_log(function(lat_lng) {
        Application.Gmap.PickerMap(lat_lng.lat(), lat_lng.lng(), func_on_geocode);
      });
    }

    selected_panel.val(tab_id);
  });

  // Po załadowaniu strony mam w hidden nazwę zaznaczonego panelu, rozwijam go i wysyłam event, żeby wywołać
  // odpowiedni kod
  $('#' + $('#log_entry_selected_panel').val()).addClass('in').trigger('shown.bs.collapse');
};
