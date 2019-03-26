json.extract! post, :id, :user_id, :content, :created_at
json.user post.user.short_data
json.articles post.articles.order('created_at DESC'), partial: 'jbuilders/article.json.jbuilder', as: :article
