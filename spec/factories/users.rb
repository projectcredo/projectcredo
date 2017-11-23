FactoryBot.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    username 'john_snow'
    email { generate :email }
    password '123456'
  end

  factory :non_authorized_user, class: 'User' do
    username 'non_authorized'
    email { generate :email }
    password '123456'
  end
end