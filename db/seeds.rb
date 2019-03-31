# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# [Paper, Article, Post, List, Reference, User].each(&:destroy_all)

@p1 = Paper.create({
  title: "The effect of storage on ammonia, cytokine, and chemokine concentrations in feline whole blood.",
  abstract: "To determine if the concentrations of ammonia and inflammatory mediators in...",
  doi: "10.1111/vec.12510",
  pubmed_id: "27447369",
  publication: "j vet emerg crit care (san antonio)"
})
@p1.authors.create({given_name: 'S', family_name: 'Author'})
@p2 = Paper.create({
  title: "Protons Potentiate GluN1/GluN3A Currents by Attenuating Their Desensitisation.",
  abstract: "N-methyl-D-aspartate (NMDA) receptors are glutamate- and glycine-gated channels composed of...",
  doi: "10.1038/srep23344",
  pubmed_id: "27000430",
  publication: "sci rep"
})
@p1.authors.create({given_name: 'S', family_name: 'Author'})

@comments = [
  {content: 'First'},
  {content: 'Second'},
  {content: 'Third'}
]

Plan.create({
  stripe_id: 'simple',
  name: 'Simple',
  interval: 'month',
  price: 5.00,
  currency: 'USD',
})

def create_lists (user, list_names)
  ActiveRecord::Base.transaction do
    list_names.each do |d|
      list = user.lists.create(name: d, description: d)
      list.tag_list.add(d.split)
      list.save
      list.comments.create(@comments.each{|c| c[:user_id] = user.id })

      (1..2).each do |n|
        post = list.posts.build(user_id: list.user_id, content: 'Test post')
        post.save(validate: false)

        article = post.articles.build(title: 'Test article')
        article.save(validate: false)

        article.papers << @p1
        article.papers << @p2

        @p1.comments.create({content: 'Test comment', user_id: user.id, list_id: list.id})
        @p2.comments.create({content: 'Test comment', user_id: user.id, list_id: list.id})
      end

      list.summaries.create!({
        user_id: user.id,
        content: 'Test summary content [cite_paper id=' + @p1.id.to_s + '] [cite_paper id=' + @p2.id.to_s + ']',
        evidence_rating: 'mixed',
      })

      Activity.create(user_id: user.id, activity_type: 'commented', addable: list.comments.first, actable: list)
      Activity.create(user_id: user.id, activity_type: 'commented', addable: list.comments.second, actable: list)
    end
  end
end

create_lists(
  User.create!(email: 'user1@example.com', password: 'password', username: 'testuser1'),
  [
    "Allergies and immigrant families",
    "Crop co-cultivation methods",
    "Exercise and depression",
    "Do cellphones cause cancer?",
  ]
)

create_lists(
  User.create!(email: 'user2@example.com', password: 'password', username: 'testuser2'),
  [
    "Protein consumption for muscular hypotrophy",
    "Efficacy of vitamin supplements",
    "The effect of probiotics on Irritable Bowel Syndrome",
    "Factors in second language acquisition 学第二语言的因素",
    "Maintaining mobility in old age"
  ]
)
