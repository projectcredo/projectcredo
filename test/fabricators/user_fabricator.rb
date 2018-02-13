Fabricator(:user) do
  username { sequence(:username) {|i| "user_#{i}"} }
  email { sequence(:email) {|i| "user#{i}@example.com"} }
  password 'password'
  confirmed_at Date.today
end
