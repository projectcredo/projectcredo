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
end
