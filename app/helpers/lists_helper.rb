module ListsHelper
  def current_user_can_moderate? list
    current_user && ListPolicy.new(current_user, list).moderate?
  end

  def current_user_can_edit? list
    current_user && ListPolicy.new(current_user, list).update?
  end

  def current_user_can_view? list
    current_user && ListPolicy.new(current_user, list).view?
  end
end
