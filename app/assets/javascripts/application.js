//= require jquery
//= require jquery-filtertable
//= require jstorage
//= require bootstrap
//= require application
//= require_tree .

var Application = {};

Application.Ui = {};
Application.Page = {};

/**
 * Kontener danych i opcji to jest ustawiane podczas budowania
 * <head> w applications.html.erb a także w różnych innych miejscach
 * wymagających interakcji rails -> js
 *
 */

Application.Options = {};
Application.Options.Get = function (variable) {
  return (application_js_options[variable] != undefined ? application_js_options[variable] : null);
};

Application.Log = function (line) {
  if (Application.Options.Get('Debug')) {
    console.log(line);
  }
};

/**
 * Wszystkie akcje obsługiwane są w oparciu o listenery publish->subscribe
 * - page-loaded: DomReady
 * - content-loaded: moment załadowania dowolnego kontentu, DomReady, ale też po załadowaniu czegoś AJAXem
 *
 */
Application.Listener = {};

Application.Listener.Publish = function (channel, payload) {
  Application.Log('Publisher: broadcasting event: ' + channel + ', payload: ' + (payload ? JSON.stringify(payload) : 'none'));
  var payload_extra = {
    url: window.location.href,
    controller: Application.Options.Get('ControllerAction')
  };
  $.jStorage.publish(channel, $.extend(payload, payload_extra));
};

Application.Listener.Subscribe = function (channel, callback) {
  $.jStorage.subscribe(channel, callback);
};

// Tutaj jedyny bind do domReady: publikuję wiadomości na podstawowych kanałach
$(document).ready(function () {
  Application.Listener.Publish('page-loaded');
  Application.Listener.Publish(Application.Options.Get('ControllerAction') + '-loaded');
  Application.Listener.Publish('content-loaded', {format: 'html'});
  Application.Log('Application: domReady');
});

