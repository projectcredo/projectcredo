Fabricator(:list) do
  name { sequence(:name) {|i| "Test list \##{i}"} }
  description { sequence(:description) {|i| "A description for list \##{i}"} }
end
