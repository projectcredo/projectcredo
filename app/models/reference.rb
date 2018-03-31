class Reference < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :activities, as: :addable, dependent: :destroy

  belongs_to :paper
  belongs_to :list, touch: true
  belongs_to :user

  validates :paper, uniqueness: { scope: :list }
  accepts_nested_attributes_for :paper

  acts_as_votable
  include HasBookmarks
end
