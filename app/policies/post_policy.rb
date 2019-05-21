class PostPolicy < ApplicationPolicy
  def create?
    user.id == record.list.user_id
  end

  def update?
    user.id == record.user_id || ListPolicy.new(user, record.list).update?
  end

  def destroy?
    user.id == record.user_id || ListPolicy.new(user, record.list).update?
  end
end
