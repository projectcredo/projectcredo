json.array!(lists) do |list|
  json.extract! list, :id, :name, :description, :slug, :pinned, :created_at
  json.updated_at time_ago_in_words(list.updated_at)
  json.link user_list_path(list.owner, list)
  json.tag_list list.tag_list
  json.comments_count list.comments.map {|c| c.self_and_descendants.length}.inject(0,&:+)
  json.likes list.cached_votes_up
  json.liked user_signed_in? && current_user.voted_for?(list)
  json.like_path polymorphic_path([list, :vote])
  json.pins list.homepages.size
  json.owner list.owner.username
end
