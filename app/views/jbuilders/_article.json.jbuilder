json.extract! article, :id, :title, :source, :url, :published_at, :bookmarks_count, :created_at
json.cover_thumb article.cover.url(:thumb)
json.cover_medium article.cover.url(:medium)
json.papers article.papers.order('created_at DESC'), partial: 'jbuilders/paper.json.jbuilder', as: :paper
json.bookmarked article.bookmarked?
