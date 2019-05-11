FactoryBot.define do
  sequence :content do |n|
    "Comment #{n}"
  end

  factory :comment do
    content { generate :content }
    user
  end
end
