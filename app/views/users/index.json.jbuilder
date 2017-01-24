json.array!(User.all) do |u|
  json.extract! u, :username
end
