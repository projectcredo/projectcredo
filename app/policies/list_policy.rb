class ListPolicy < ApplicationPolicy
  def create?
    true
  end

  def show?
    true
  end

  def update?
    user && user.id == record.user_id
  end

  def destroy?
    user && user.id == record.user_id
  end
end
