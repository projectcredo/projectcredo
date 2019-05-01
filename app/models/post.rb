class Post < ApplicationRecord

  belongs_to :user
  belongs_to :list
  has_many :articles, dependent: :destroy
  validates :user, :presence => true
  validates :list, :presence => true
  validates :content, presence: true

  include HasBookmarks

  def user_short() user.short_data end
end
