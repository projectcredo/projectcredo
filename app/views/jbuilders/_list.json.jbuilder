json.extract! list, :id, :name, :slug, :description, :created_at
json.cover_thumb list.cover.url(:thumb)
json.cover_url list.cover.url(:cover)
json.owner list.user.short_data
json.tags list.tags
json.summaries list.summaries.order('created_at DESC'), partial: 'jbuilders/summary.json.jbuilder', as: :summary
json.posts list.posts.order('updated_at DESC'), partial: 'jbuilders/post.json.jbuilder', as: :post
json.pins list.homepages.size
json.pinned current_user ? current_user.homepage.lists.include?(list) : false
json.can_update ListPolicy.new(current_user, list).update?
json.comments get_json_tree(list.comments.roots.includes(:user).order('cached_votes_up DESC, created_at ASC'))
