class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :set_locale
	add_flash_types :success, :danger, :info, :warning

 	protected

 	def configure_permitted_parameters
    	added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    	devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    	devise_parameter_sanitizer.permit :account_update, keys: added_attrs
 	end

 	private

 def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
