class ListMembership < ApplicationRecord

  enum role: {subscriber: 10, contributor: 20, moderator: 30, owner: 40 }

  validates_uniqueness_of :role,
    if: ->{role == "owner"},
    scope: :list,
    message: "must be transferred with current list owner's permission"

  belongs_to :user
  belongs_to :list

  def permissions
    case role
    when 'owner'        then ['read','write','moderate','delete']
    when 'moderator'    then ['read','write','moderate']
    when 'contributor'  then ['read','write']
    when 'subscriber'   then ['read']
    end
  end

  def can_view?
    !(list.visibility == 'private')
  end

  def can_edit?
    owner? || moderator? || contributor?
  end

  def can_moderate?
    owner? || moderator?
  end
end
