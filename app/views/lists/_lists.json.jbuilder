json.array!(lists) do |list|
  json.extract! list, :id, :name, :description, :slug, :created_at
  json.pinned current_user ? current_user.homepage.lists.include?(list) : false
  json.updated_at time_ago_in_words(list.updated_at)
  json.link user_list_path(list.owner, list)
  json.tag_list list.tag_list
  json.comments_count list.comments.map {|c| c.self_and_descendants.length}.inject(0,&:+)
  json.likes list.cached_votes_up
  json.liked user_signed_in? && current_user.voted_for?(list)
  json.like_path polymorphic_path([list, :vote])
  json.pins list.homepages.size
  json.owner list.owner.username

  if @include_activities
    json.activities do |json|
      json.message recent_activity_msg(list)

      json.last_activity list.activities.last(3).reverse do |a|
        json.user a.user.username
        json.type a.activity_type
        json.updated_at time_ago_in_words(a.updated_at)
        json.addable case a.activity_type
          when 'added'
            truncate(a.addable.paper.title, length: 150)
          when 'commented'
            truncate(a.addable.content, length: 250)
        end
        json.addable_href case a.activity_type
          when 'added'
            a.addable.paper.direct_link
        end
      end
    end
  end
end