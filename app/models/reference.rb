class Reference < ApplicationRecord
  default_scope { order( cached_votes_up: :desc ) }

  acts_as_votable

  belongs_to :paper
  belongs_to :list

  # Consider moving validations to the schema:
  # http://stackoverflow.com/a/1449466/1042144
  validates :paper, uniqueness: { scope: :list }
end
