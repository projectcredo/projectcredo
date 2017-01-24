json.current_user current_user.username
json.can_moderate current_user.can_moderate?(@list)
json.access @list.access

json.members do
  json.array!(@members)  do |member|
    json.username member[:username]
    json.role member[:role]
  end
end