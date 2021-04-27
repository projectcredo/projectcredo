class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, :last_name, :username, :email, :about, :country, :city, :website, :avatar, :cover
    ])
  end

  private
    def current_user
      return current_api_user
    end
end
