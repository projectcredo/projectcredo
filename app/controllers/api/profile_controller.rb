class Api::ProfileController < Api::ApplicationController
  before_action :set_user

  def index
    @visible_lists = @user.lists.ranked

    render 'jbuilders/_profile.json.jbuilder', {locals: {user: @user}}
  end

  private
    def set_user
      @user = User.find_by 'LOWER(username) = ?', params[:username].downcase
      not_found unless @user
    end
end
