module ListsHelper
  def current_user_can_moderate? list
    current_user && current_user.can_moderate?(list)
  end

  def current_user_can_edit? list
    current_user && (current_user.can_edit?(list) || list.accepts_public_contributions?)
  end

  def current_user_can_view? list
    current_user && current_user.can_view?(list)
  end

  def recent_activity_msg list

    #only if List has activities
    if list.activities.empty?
      return nil
    end

    #set the definition of recent activities you want to show
    recent_activities = list.activities.last(20)

    #group activities based on activity typet
    grouped_activities = recent_activities.group_by(&:activity_type)

    #references added
    papers_added = grouped_activities["added"].length
    adds_msg = "#{pluralize(papers_added, 'paper')} added"

    commenters = grouped_activities["commented"].pluck(:user_id).uniq.length
    comments_msg = "#{pluralize(commenters, 'person')} commented"

    activity_msg = [adds_msg,comments_msg].to_sentence

    return activity_msg
  end
end
