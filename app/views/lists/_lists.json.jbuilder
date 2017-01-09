json.array!(lists) do |list|
  json.extract! list, :id, :name, :description
  json.tag_list list.tag_list
  json.owner list.owner.username
end
