json.current_user current_user.username
json.can_moderate (if @list.persisted? then current_user.can_edit?(@list) else true end)
json.access @list.access
json.owner (if @list.persisted? then @list.owner.username else current_user.username end)

json.all_users do
  json.array!(@list.list_memberships.where.not(role: "owner"))  do |member|
    json.username User.find(member.user_id).username
    json.role member.role
  end
  json.array!(User.where.not(id: @list.list_memberships.pluck(:user_id)) - [current_user]) do |nonmember|
    json.username nonmember.username
    json.role 'nonmember'
  end
end