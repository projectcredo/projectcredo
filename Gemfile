source 'https://rubygems.org'
ruby '2.5.1'

# ProjectCredo specific gems
gem 'devise', '~> 4.4.0'
gem 'acts-as-taggable-on', '~> 4.0'
gem 'acts_as_votable', '~> 0.10.0'
gem 'paperclip', '~> 5.2.0'
gem 'aws-sdk', '~> 2.3.0'
gem 'impressionist'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

gem 'stripe'

gem 'closure_tree', '~> 6.1.0'
gem 'postmark-rails', '~> 0.14.0'
gem 'gibbon'
gem 'rails_autolink'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0', '< 5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
# gem 'jquery-rails', '~> 4.1.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'rake', group: :test

# Use webpacker to build assets
gem 'webpacker', '~> 3.0'
gem 'will_paginate'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.6'
  gem 'minitest-rails', '~> 3.0.0'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'meta_request'
  gem 'factory_bot_rails'
  gem 'fabrication', '~> 2.16.0'
  gem 'foreman'
end

group :development do
  gem 'pry-rails'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'rails_real_favicon'
end

group :development do
  gem 'stripe-ruby-mock', '~> 2.5.4', :require => 'stripe_mock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
