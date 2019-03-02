class Article < Paper
  acts_as_taggable
  acts_as_taggable_on :biases, :methodologies

  has_and_belongs_to_many :lists
  has_many :papers, foreign_key: :parent_id

end
