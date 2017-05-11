json.array!(references) do |r|
  json.ignore_nil!
  json.extract! r, :id, :created_at
  json.type r.class.to_s.downcase
  json.votes r.cached_votes_up
  json.voted user_signed_in? && current_user.voted_for?(r)
  json.vote_path polymorphic_path([r, :vote])
  json.paper do |json|
    json.(r.paper,
      :id,
      :abstract_editable,
      :abstract,
      :published_at,
      :pubmed_id,
      :doi,
      :title
    )
    json.publication r.paper.publication
    json.links r.paper.links
    json.tag_list r.paper.tag_list
    json.authors r.paper.authors
    json.direct_link r.paper.direct_link
  end
  json.notes r.comments.order('cached_votes_up DESC, created_at DESC') do |n|
    json.id n.id
    json.type n.class.to_s.downcase
    json.content n.content
    json.votes n.cached_votes_up
    json.voted user_signed_in? && current_user.voted_for?(n)
    json.vote_path polymorphic_path([n, :vote])
    json.created_at n.created_at
    json.updated_at n.updated_at
    json.time_ago time_ago_in_words(n.created_at)
    json.user User.find(n.user_id).username
  end
end