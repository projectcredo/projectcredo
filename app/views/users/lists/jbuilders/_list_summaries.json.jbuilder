json.array!(summaries) do |s|
  json.extract! s, :id, :evidence_rating, :content, :created_at, :updated_at
  json.time_ago time_ago_in_words(s.created_at)
  json.edit_path edit_user_list_summary_path(user_list_id: @list.slug, id: s.id)
  json.user s.user.username
  json.type s.class.to_s.downcase
  json.votes s.cached_votes_up
  json.voted user_signed_in? && current_user.voted_for?(s)
  json.vote_path polymorphic_path([s, :vote])
end
