module ListsHelper
  def current_user_can_moderate? list
    current_api_user && ListPolicy.new(current_api_user, list).moderate?
  end

  def current_api_user_can_edit? list
    current_api_user && ListPolicy.new(current_api_user, list).update?
  end

  def current_api_user_can_view? list
    current_api_user && ListPolicy.new(current_api_user, list).view?
  end
end
