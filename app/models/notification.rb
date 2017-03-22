class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, :activity_id, presence: true

  def actable
    actable = case self.activity.activity_type
              when "commented"
                self.activity.actable
              when "added"
                self.activity.actable
              end

    return actable
  end

  def added
    added = case self.activity.activity_type
              when "commented"
                self.activity.addable.content
              when "added"
                self.activity.addable.paper.title
              end

    return added
  end

  def username
    self.activity.user.username
  end

  def preposition
    preposition = case self.activity.activity_type
              when "commented"
                "on"
              when "added"
                "to"
              end

    return preposition
  end
end
