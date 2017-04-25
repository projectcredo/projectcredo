module ActivitiesHelper
  def create_activity(actable: ,activity_type: ,addable: nil)
    Activity.create(user_id: current_user.id,
                        activity_type: activity_type,
                        addable: addable,
                        actable: actable)
  end

  def create_activity_and_notifications(actable: ,activity_type:, users: ,addable: nil)
    activity = create_activity(actable: actable, activity_type: activity_type, addable: addable)
    create_notifications(users: users, activity: activity)
  end
end