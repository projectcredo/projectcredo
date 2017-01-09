# Force lowercase for Acts on Taggable
ActsAsTaggableOn.force_lowercase = true

module ActsAsTaggableOn
  class Tag
    validates :name, format: {with: /\A[\p{N}\p{L} ]+\z/, message: "cannot have special characters"}
  end
end
