json.current_user current_user.username
json.can_moderate true
json.access @list.access

json.members do
  json.array!(@members)  do |member|
    json.username member[:username]
    json.role member[:role]
  end
end