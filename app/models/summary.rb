class Summary < ApplicationRecord
  # Modules
  acts_as_votable

  # Scopes
  scope :ranked, -> {
    order('cached_votes_up DESC, updated_at DESC')
  }

  # Attributes
  enum evidence_rating: {'too early': 10, mixed: 20, conclusive: 30 }

  # Associations
  belongs_to :user
  belongs_to :list

  # Validations
  validates :user_id, :list_id, :content, :evidence_rating, presence: true
  validates :content, length: { maximum: 2000 }

  # Methods
  def evidence_ratings
    [
      'too early',
      'mixed',
      'conclusive'
    ]
  end
end