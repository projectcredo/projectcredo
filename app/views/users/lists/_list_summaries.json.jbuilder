json.array!(summaries) do |s|
  json.extract! s, :id, :evidence_rating, :content, :created_at, :updated_at
  json.user s.user.username
end
