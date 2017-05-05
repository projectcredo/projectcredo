json.array!(references) do |r|
  json.extract! r, :id, :created_at
  json.type r.class.to_s.downcase
  json.permalink user_list_reference_path(r.list.user, r.list, r)
  json.tag_list r.paper.tag_list
  json.votes r.cached_votes_up
  json.voted user_signed_in? && current_user.voted_for?(r)
  json.vote_path polymorphic_path([r, :vote])
  json.abstract (r.paper.abstract.nil? ? '' : r.paper.abstract)
  json.abstract_editable r.paper.abstract_editable
  json.abstract_form (r.paper.abstract.nil? ? '' : r.paper.abstract)
  json.authors r.paper.authors
  json.age r.paper.age
  json.paper r.paper
  json.direct_link r.paper.direct_link
  json.comments r.comments
  json.notes r.comments.order('cached_votes_up DESC, created_at ASC') do |n|
    json.id n.id
    json.type n.class.to_s.downcase
    json.content n.content
    json.votes n.cached_votes_up
    json.voted user_signed_in? && current_user.voted_for?(n)
    json.vote_path polymorphic_path([n, :vote])
    json.updated_at n.updated_at
    json.user User.find(n.user_id).username
  end
end