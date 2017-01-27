json.array!(@lists) do |list|
  json.extract! list, :id, :name, :description, :slug
  json.createdAt do |t|
    json.readable list.created_at.strftime("%b %d, %Y at %l:%M%P")
    json.integer list.updated_at.to_i
  end
  json.updatedAt do |t|
    json.readable list.updated_at.strftime("%b %d, %Y at %l:%M%P")
    json.integer list.updated_at.to_i
  end
  json.tagList list.tag_list
  json.commentsCount list.comments.map {|c| c.self_and_descendants.length}.inject(0,&:+)
  json.owner list.owner.username
  json.pinned current_user && current_user.homepage.lists.include?(list)
  json.editable current_user && current_user.can_edit?(list)
  json.voted current_user && current_user.voted_for?(list)
  json.votes list.get_likes.size.to_s
end
