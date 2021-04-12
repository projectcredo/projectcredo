json.array!(bookmarks) do |bookmark|
  json.extract! bookmark, :id, :bookmarkable_type, :created_at

  if bookmark.bookmarkable_type == 'Paper'
    json.paper bookmark.bookmarkable, partial: 'jbuilders/paper.json.jbuilder', as: :paper
  end
end
