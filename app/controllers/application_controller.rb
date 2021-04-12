class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, :last_name, :username, :email, :about, :country, :city, :website, :avatar, :cover
    ])
  end

#   include Pundit
#   require 'pp'
#
#   # Prevent CSRF attacks by raising an exception.
#   # For APIs, you may want to use :null_session instead.
#   protect_from_forgery with: :exception
#   before_action :configure_permitted_parameters, if: :devise_controller?
#   after_action :store_pre_signin_path
#   before_action :set_current_user
#
#   force_ssl if: ->{ Rails.env.production? }, except: :lets_encrypt
#
#   rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
#
#   def set_current_user
#     User.current = current_user
#   end
#
#   protected
#     def configure_permitted_parameters
#       added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
#       devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
#       devise_parameter_sanitizer.permit :account_update, keys: added_attrs.push(
#         :avatar, :cover, :about, :country, :city, :website, :first_name, :last_name
#       )
#     end
#
#     def store_pre_signin_path
#       return if !request.get? || request.xhr?
#
#       user_paths = [
#         "/users/sign_in",
#         "/users/sign_up",
#         "/users/password/new",
#         "/users/password/edit",
#         "/users/confirmation",
#         "/users/sign_out"
#       ]
#
#       store_location_for(:user, request.fullpath) unless user_paths.include?(request.path)
#     end
#
#     def ajax_redirect_to(redirect_uri)
#       render js: "window.location.replace('#{redirect_uri}');"
#     end
#
  private
    def current_user
      return current_api_user
    end

#     def ensure_current_user
#       unless current_user
#         flash[:alert] = 'You must sign in to perform this action'
#
#         respond_to do |format|
#           format.html { return redirect_to new_user_session_path }
#           format.js { return ajax_redirect_to(new_user_session_path) }
#         end
#       end
#     end
#
#     def not_found
#       raise ActionController::RoutingError.new('Not Found')
#     end
#
#     def user_not_authorized(exception)
#       policy_name = exception.policy.class.to_s.underscore
#       message = t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)
#
#       respond_to do |format|
#         format.json { render json: { type: 'error', message: message}, status: :unauthorized  }
#         format.html {
#           flash[:alert] = message
#           redirect_to(request.referrer || root_path)
#         }
#       end
#     end
end
