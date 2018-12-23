class Article < Paper
  acts_as_taggable
  acts_as_taggable_on :biases, :methodologies

end
