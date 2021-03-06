FactoryBot.define do
  sequence :name do |n|
    "Test list \##{n}"
  end

  sequence :description do |n|
    "A description for list \##{n}"
  end

  factory :list do
    name { generate :name }
    description { generate :description }
    tag_list { 'tag1, tag2, tag3' }
    user
  end

end