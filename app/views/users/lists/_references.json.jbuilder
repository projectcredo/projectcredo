json.array!(references) do |r|
  json.extract! r, :id, :created_at
  json.permalink user_list_reference_path(r.list.user, r.list, r)
  json.tag_list r.paper.tag_list
  json.recommends r.cached_votes_up
  json.recommended user_signed_in? && current_user.voted_for?(r)
  json.recommend_path polymorphic_path([r, :vote])
  json.abstract (r.paper.abstract.nil? ? '' : r.paper.abstract)
  json.authors r.paper.authors
  json.age r.paper.age
  json.paper r.paper
  json.comments r.comments
  json.notes r.comments.order('cached_votes_up DESC, created_at ASC') do |n|
    json.id n.id
    json.content n.content
    json.upvotes n.cached_votes_up
    json.upvoted user_signed_in? && current_user.voted_for?(n)
    json.updated_at n.updated_at
    json.user User.find(n.user_id).username
    json.upvote_path polymorphic_path([n, :vote])
  end
end