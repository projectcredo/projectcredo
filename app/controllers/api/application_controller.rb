class Api::ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit
  require 'pp'
  before_action :set_current_user

  def set_current_user
    @current_user = nil
    if (current_api_user)
      User.current = current_api_user
      @current_user = current_api_user
    end
  end
end
