class Highlight < ApplicationRecord
  belongs_to :user
  belongs_to :paper

  validates :substring, presence: true
  validate :must_be_paper_substring, :must_be_unique_substring

  def must_be_paper_substring
    if !paper.abstract.include?(substring)
      errors.add(:substring, 'must be a highlight within the paper abstract')
    end
  end

  def must_be_unique_substring
    if paper.abstract.scan(substring).length > 1
      errors.add(:substring, 'must be a unique passage within the paper abstract')
    end
  end
end
