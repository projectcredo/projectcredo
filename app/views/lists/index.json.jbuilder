json.array!(lists) do |list|
  json.extract! list, :id, :name, :description, :created_at, :updated_at
  json.tag_list list.tag_list
  json.comments_count list.comments.map {|c| c.self_and_descendants.length}.inject(0,&:+)
  json.owner list.owner.username
end
