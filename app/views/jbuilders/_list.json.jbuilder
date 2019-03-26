json.extract! list, :id, :name, :slug, :description, :created_at
json.cover_thumb list.cover.url(:thumb)
json.cover_url list.cover.url(:cover)
json.owner list.owner.short_data
json.tags list.tags
json.others list.others
json.summaries list.summaries.order('created_at DESC'), partial: 'jbuilders/summary.json.jbuilder', as: :summary
json.posts list.posts.order('created_at DESC'), partial: 'jbuilders/post.json.jbuilder', as: :post
