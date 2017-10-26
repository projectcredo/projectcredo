FactoryGirl.define do

  factory :activity do
    activity_type 'created'
    user
  end

end