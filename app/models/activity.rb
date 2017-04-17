class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :actable, polymorphic: true
  belongs_to :addable, polymorphic: true

  has_many :notifications, dependent: :destroy

  validates :user_id, :activity_type, :actable_type, :actable_id, presence: true

end
