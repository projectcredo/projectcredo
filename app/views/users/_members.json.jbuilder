json.array!(members) do |member|
  json.extract! member, :username
end
