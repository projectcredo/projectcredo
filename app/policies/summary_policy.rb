class SummaryPolicy < ApplicationPolicy
  def create?
    ListPolicy.new(user, record.list).update?
  end

  def update?
    ListPolicy.new(user, record.list).update?
  end

  def destroy?
    ListPolicy.new(user, record.list).update?
  end
end
