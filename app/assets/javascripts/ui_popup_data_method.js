Application.Ui.PopupDataMethod = function () {
  var container = $('#modal-popup-1');
  var func_popup = function (msg, color, on_ok) {
    if (color == 'danger') {
      container.find('.modal-header-title').html('<span class="text-danger"><span class="glyphicon glyphicon-exclamation-sign icon-margin"></span> Uwaga</span>');
    }
    else {
      container.find('.modal-header-title').html('<span class="glyphicon glyphicon-info-sign icon-margin"></span>Potwierdzenie');
    }
    container.find('.modal-body').html(msg);
    var s_button = container.find('.modal-popup-btn-ok');
    s_button.removeAttr('class').addClass('modal-popup-btn-ok').addClass('btn').addClass('btn-' + color);
    s_button.attr('disabled', false);
    s_button.unbind().bind('click', function (e) {
      e.preventDefault();
      $(this).attr("disabled", "disabled");
      on_ok();
    });
    container.modal('show');
  };

  $('form').each(function () {
    var form = $(this);
    var button = form.find('input[data-confirm]');
    if (button.length > 0) {
      Application.Log('Ui.Popup.DataMethod: ' + form.attr('action'));
      form.bind('submit', function(e) {
        e.preventDefault();
        func_popup(button.attr('data-confirm'), 'primary', function() {
          form.unbind('submit').trigger('submit');
        })
      })
    }
  });
};

Application.Listener.Subscribe('content-loaded', Application.Ui.PopupDataMethod);
