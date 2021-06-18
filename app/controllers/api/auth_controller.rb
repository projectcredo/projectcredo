class Api::AuthController < Api::ApplicationController
  before_action :ensure_current_user, only: [:me]

  def me
    render 'jbuilders/_user.json.jbuilder', {locals: {user: @current_user}}
  end
end
