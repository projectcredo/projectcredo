class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :actable, polymorphic: true
  belongs_to :addable, polymorphic: true

  has_many :notifications, dependent: :destroy

  validates :user_id, :activity_type, :actable_type, :actable_id, presence: true

  def sentence_parts
    sentence_parts = Hash.new
    case self.activity_type
    when "commented"
      sentence_parts[:added] = self.addable.content
      sentence_parts[:preposition] = "on"
    when "added"
      sentence_parts[:added] = self.addable.paper.title
      sentence_parts[:preposition] = "to"
      sentence_parts[:paper_direct_link] = self.addable.paper.direct_link
    end

    sentence_parts[:username] = self.user.username

    return sentence_parts
  end
end
