class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, :activity_id, presence: true

end
