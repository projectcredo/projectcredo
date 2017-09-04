class Activity < ApplicationRecord
  enum activity_type: {created: 10, added: 20, commented: 30 }

  belongs_to :user
  belongs_to :actable, polymorphic: true
  belongs_to :addable, polymorphic: true

  has_many :notifications, dependent: :destroy

  validates :user_id, :activity_type, :actable_type, :actable_id, presence: true

  def sentence_parts
    parts = Hash.new
    case self.activity_type
    when "commented"
      parts[:added] = self.addable.content
      parts[:preposition] = "on"
    when "added"
      parts[:added] = self.addable.paper.title
      parts[:preposition] = "to"
      parts[:paper_direct_link] = self.addable.paper.direct_link
    when "created"
    end

    parts[:username] = self.user.username

    return parts
  end
end
