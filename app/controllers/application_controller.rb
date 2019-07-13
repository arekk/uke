class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper :all

  before_action :set_locale

  protected

  def set_locale
    if request.env['HTTP_ACCEPT_LANGUAGE'] && !(locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first).nil?
      begin
        I18n.locale = locale
      rescue I18n::InvalidLocale
        I18n.locale = I18n.default_locale
      end
    end
  end
end
