class Plan < ApplicationRecord
  has_many :subscriptions

  validates :name, :interval, :price, :currency, presence: true
end
