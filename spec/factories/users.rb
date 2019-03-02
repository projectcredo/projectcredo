FactoryBot.define do
  sequence :username do |n|
    "john_snow_#{n}"
  end

  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    username { generate :username }
    email { generate :email }
    password { '123456' }
    after(:create) { |user| user.confirm }
  end
end