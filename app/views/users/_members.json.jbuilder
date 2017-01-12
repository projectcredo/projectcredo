json.array!(users) do |u|
  json.extract! u, :username
end
