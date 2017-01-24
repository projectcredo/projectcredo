json.array!(@members)  do |member|
  json.username member[:username]
  json.role member[:role]
end