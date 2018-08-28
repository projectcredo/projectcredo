FactoryBot.define do
  sequence :stripe_id do |n|
    "stripe_#{n}"
  end
  
  sequence :plan_name do |n|
    "Plan #{n}"
  end

  factory :plan do
    stripe_id { generate :stripe_id }
    name { generate :plan_name }
    interval '1 month'
    price 5.0
    currency 'USD'
  end
end
