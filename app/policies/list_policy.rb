class ListPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    (membership && membership.can_edit?) || (record && record.accepts_public_contributions?)
  end

  def moderate?
    membership && membership.can_moderate?
  end

  def show?
    membership && membership.can_view?
  end

  def membership
    record && record.list_memberships.find_by(user: user)
  end
end
