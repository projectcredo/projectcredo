module NotificationsHelper
  def create_notifications(users: ,activity: )
    users.each do |u|
      if u != current_user
        Notification.create(user_id: u.id,
                        activity_id: activity.id,
                        has_read: false)
      end
    end
  end
end