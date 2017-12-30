class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #prevent the user from going back to the forms when they hit the back button
  before_action :set_cache_buster , only: [:first_time_tutor, :sign_in, :sign_up]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "#{1.year.ago}"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fist_name, :last_name, :avatar])
  end
end
