FactoryBot.define do
  sequence :title do |n|
    "Paper \##{n}"
  end

  sequence :abstract do |n|
    "An abstract for paper \##{n}"
  end

  sequence :doi do |n|
    "10.1111/vec.#{n}"
  end

  sequence :pubmed_id do |n|
    "10000#{n}"
  end

  factory :paper do
    title { generate :name }
    published_at Time.now
    abstract { generate :description }
    doi { generate :doi }
    pubmed_id { generate :pubmed_id }
    abstract_editable true
    paper_editable true
  end

end