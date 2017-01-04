 class ActsAsTaggable::Tag
  require 'acts_as_taggable_on/tag'

  validates :name, format: { with: /\A[a-zA-Z0-9 ]+\Z/ }

 end
