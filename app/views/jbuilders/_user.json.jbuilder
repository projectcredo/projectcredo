json.extract! user, :id, :email, :first_name, :last_name, :username, :full_name, :country, :city, :website, :about, :location, :created_at
json.avatar do
   json.present user.avatar.present?
   json.thumb user.avatar.url(:thumb)
   json.medium user.avatar.url(:medium)
end
json.cover do
   json.present user.cover.present?
   json.thumb user.cover.url(:thumb)
   json.cover user.cover.url(:cover)
end
