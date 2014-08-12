Application.Listener.Subscribe('content-loaded', function() {

  // Wyszukaj elementy, których kliknięcie ma zaznaczyć radio
  $('.radio-select-element').click(function(e) {
    var radio = $($(this).attr('data-radio-select-element-selector'));
    var state = $($(this).attr('data-radio-select-state-element-selector'));

    radio.attr('checked', 'checked');
    var prev = $(state.attr('data-radio-select-state'));
    if (prev.length > 0) {
      prev.removeAttr('checked');
    }
    state.attr('data-radio-select-state', '#' + radio.attr('id'));
  });
});
