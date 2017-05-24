class Summary < ApplicationRecord
  enum evidence_rating: {incomplete: 10, mixed: 20, conclusive: 30 }

  belongs_to :user
  belongs_to :list

  validates :user_id, :list_id, :content, :evidence_rating, presence: true
  validates :content, length: { maximum: 2000 }

end