# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

list_names =[
  "Allergies and immigrant families",
  "Crop co-cultivation methods",
  "Exercise and depression",
  "Do cellphones cause cancer?",
  "Protein consumption for muscular hypotrophy",
  "Efficacy of vitamin supplements",
  "The effect of probiotics on Irritable Bowel Syndrome",
  "Factors in second language acquisition 学第二语言的因素",
  "Maintaining mobility in old age",
]

papers = [
  {
    title: "The effect of storage on ammonia, cytokine, and chemokine concentrations in feline whole blood.",
    abstract: "To determine if the concentrations of ammonia and inflammatory mediators in...",
    doi: "10.1111/vec.12510",
    pubmed_id: "27447369",
    publication: "j vet emerg crit care (san antonio)"
  },
  {
    title: "Protons Potentiate GluN1/GluN3A Currents by Attenuating Their Desensitisation.",
    abstract: "N-methyl-D-aspartate (NMDA) receptors are glutamate- and glycine-gated channels composed of...",
    doi: "10.1038/srep23344",
    pubmed_id: "27000430",
    publication: "sci rep"
  }
]


ActiveRecord::Base.transaction do
  u = User.create(email: 'user@example.com', password: 'password', username: 'testuser')

  comments = [
    {content: 'First', user_id: u.id},
    {content: 'Second', user_id: u.id, commentable_id: nil, commentable_type: nil},
    {content: 'Third', user_id: u.id, commentable_id: nil, commentable_type: nil}
  ]

  p1 = Paper.create papers[0]
  p2 = Paper.create papers[1]

  list_names.each do |d|
    l = u.lists.create(name: d, description: d)
    l.tag_list.add(d.split)

    r1 = l.references.create(paper: p1, user: u)
    r2 = l.references.create(paper: p2, user: u)

    r1.comments.find_or_create_by_path comments
    r2.comments.find_or_create_by_path comments
  end
end
