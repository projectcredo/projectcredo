class Homepage < ApplicationRecord
  belongs_to :user

  has_and_belongs_to_many :lists
end
