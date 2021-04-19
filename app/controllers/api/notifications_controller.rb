class Api::NotificationsController < Api::ApplicationController
  before_action :ensure_current_user

  def index
    @notifications = current_api_user.notifications.order(created_at: :desc).paginate(:page => params[:page], :per_page => 30)

    render 'jbuilders/_notifications.json.jbuilder'
  end

  def unread
    @notifications = current_api_user.unread_notifications.last(20).reverse

    render 'jbuilders/_notifications.json.jbuilder'
  end

  def read_notifications
    if current_api_user.unread_notifications
      puts current_api_user.unread_notifications.update_all(has_read: true)
    end

    respond_to do |format|
      format.json
    end
  end

end
