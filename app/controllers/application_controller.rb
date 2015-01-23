class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_javascript_globals
  before_action :set_language

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def set_javascript_globals
    gon.is_admin = current_user && current_user.admin?
    gon.is_logged_in = !current_user.nil?
  end

  def set_language
    if current_user && I18n.locale_available?(current_user.locale)
      I18n.locale = current_user.locale
    end
  end
end
