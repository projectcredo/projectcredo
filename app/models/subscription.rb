class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :stripe_id, presence: true
end
