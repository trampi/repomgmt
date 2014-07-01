class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :set_is_admin_for_frontend

	protected
	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) << :name
	end

	def set_is_admin_for_frontend
		gon.is_admin = current_user && current_user.admin?
	end
end
