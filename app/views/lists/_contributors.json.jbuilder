json.array!(list.list_memberships.where(role: 'contributor'))  do |member|
  json.id member.user.id
  json.username member.user.username
  json.avatar member.user.avatar(:thumb)
end
