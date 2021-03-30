DeviseTokenAuth.setup do |config|
#   config.enable_standard_devise_support = true

  config.change_headers_on_each_request = false
  config.token_lifespan = 20.weeks
end
