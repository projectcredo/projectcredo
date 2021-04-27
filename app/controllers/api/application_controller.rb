class Api::ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :set_current_user
  respond_to :json

  def set_current_user
    @current_user = nil
    if (current_api_user)
      User.current = current_api_user
      @current_user = current_api_user
    end
  end

  def ensure_current_user
    unless current_api_user
      render json: {status: 'Unauthorized'}, status: :unauthorized
    end
  end

  def not_found
    render json: {status: 'Not found'}, status: :not_found
  end

  def forbidden
    render json: {status: 'Forbidden'}, status: :forbidden
  end

  def bad_request
    render json: {status: 'Bad request'}, status: :bad_request
  end
end
