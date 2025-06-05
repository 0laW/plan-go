class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    if session[:first_login].nil?
      session[:first_login] = true
      onboarding_steps_path(step: "welcome")
    else
      super
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username user_image_url])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username user_image_url])
  end
end
