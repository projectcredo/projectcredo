FactoryBot.define do
  sequence :post_content do |n|
    "Post #{n}"
  end

  factory :post do
    content { generate :post_content }
    user
    list
  end
end
