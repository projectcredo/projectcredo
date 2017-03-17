module ActivitiesHelper
  def create_activity(actable: ,activity_type: ,addable: nil)
    Activity.create(user_id: current_user.id,
                        activity_type: activity_type,
                        addable_id: addable.id,
                        actable_type: actable.class.name,
                        actable_id: actable.id)
  end
end