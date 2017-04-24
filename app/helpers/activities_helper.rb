module ActivitiesHelper
  def create_activity(actable: ,activity_type: ,addable: nil)
    Activity.create(user_id: current_user.id,
                        activity_type: activity_type,
                        addable_id: if addable.nil? then nil else addable.id end,
                        addable_type: if addable.nil? then nil else addable.class.name end,
                        actable_type: actable.class.name,
                        actable_id: actable.id)
  end

  def create_activity_and_notifications(actable: ,activity_type:, users: ,addable: nil)
    activity = create_activity(actable: actable, activity_type: activity_type, addable: addable)
    create_notifications(users: users, activity: activity)
  end
end