class NotificationsController < ApplicationController
  before_action :ensure_current_user

  def index
    @notifications = current_user.notifications
  end

  def read_notifications
    if current_user.unread_notifications
      current_user.unread_notifications.update_all(has_read: true)
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js { render 'layouts/read_notifications.js.erb' }
    end
  end

end
