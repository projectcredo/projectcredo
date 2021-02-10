FactoryBot.define do
  sequence :summary_content do |n|
    "Summary #{n}"
  end

  factory :summary do
    content { generate :summary_content }
    evidence_rating { 20 }
    user
    list
  end
end
