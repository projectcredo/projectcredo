module ActivitiesHelper
  def create_activity(actable: ,activity_type: ,addable: nil)
    Activity.create(user_id: current_user.id,
                        activity_type: activity_type,
                        addable_id: if addable.nil? then nil else addable.id end,
                        actable_type: actable.class.name,
                        actable_id: actable.id)
  end
end