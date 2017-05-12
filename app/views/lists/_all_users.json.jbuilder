json.array!(list.list_memberships.where.not(role: "owner"))  do |member|
  json.username User.find(member.user_id).username
  json.role member.role
end
json.array!(User.where.not(id: list.list_memberships.pluck(:user_id)) - [current_user]) do |nonmember|
  json.username nonmember.username
  json.role 'nonmember'
end
