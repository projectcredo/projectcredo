json.extract! user, :first_name, :last_name, :username, :full_name, :country, :city, :website, :location, :created_at
json.avatar_thumb user.avatar.url(:thumb)
json.avatar_medium user.avatar.url(:medium)
json.cover user.cover.url(:cover)
