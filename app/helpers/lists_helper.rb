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

  def recent_activity list
    if list.activities.empty?
      return []
    end

    recent_activities = list.activities.last(20)
    grouped_activities = recent_activities.group_by(&:activity_type)

    activity = []

    adds_by_users = grouped_activities["added"].group_by(&:user_id)
    activity << adds_by_users.map do |user, adds|
      username = User.find(user).username
      papers_count = pluralize(adds.flatten.length, 'paper')
      "#{username} added #{papers_count}"
    end

    commenters = grouped_activities["commented"].pluck(:user_id).uniq
    last_3_commenters = commenters.last(3).map{|c| User.find(c).username}.to_sentence
    more_cmts_cnt = commenters.length - 3
    more_cmts_msg = "and #{pluralize(more_cmts_cnt, 'other')}" if more_cmts_cnt > 0

    activity << "#{last_3_commenters} #{more_cmts_msg}commented"

    return activity.flatten
  end
end
