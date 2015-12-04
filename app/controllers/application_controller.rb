class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper :all

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def set_locale
    unless (locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first).nil?
      begin
        I18n.locale = locale
      rescue I18n::InvalidLocale
        I18n.locale = I18n.default_locale
      end
    end
  end

  def configure_permitted_parameters
    [:sign_up, :account_update].each do |action|
      [:nickname, :location, :scanner_model, :trx_model, :radioscaner_forum_login].each do |attr|
        devise_parameter_sanitizer.for(action) << attr
      end
    end
  end
end
