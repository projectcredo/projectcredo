class NotificationsController < ApplicationController
  before_action :ensure_current_user

  def index
    @notifications = current_user.notifications
  end

  def read_notifications

  end

end
