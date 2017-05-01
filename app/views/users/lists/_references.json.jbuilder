json.array!(references) do |r|
  json.extract! r, :id, :created_at
  json.permalink user_list_reference_path(r.list.user, r.list, r)
  json.tag_list r.paper.tag_list
  json.comments_count r.comments.map {|c| c.self_and_descendants.length}.inject(0,&:+)
  json.recommends r.cached_votes_up
  json.recommended user_signed_in? && current_user.voted_for?(r)
  json.recommend_path polymorphic_path([r, :vote])
  json.abstract (r.paper.abstract.nil? ? '' : r.paper.abstract)
  json.authors r.paper.authors
  json.comments r.comments
  json.age r.paper.age
  json.paper r.paper
end