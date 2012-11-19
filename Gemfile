source 'https://rubygems.org'

gem 'rails', '3.2.2'

# gem 'craftoid' #, git: 'git@github.com:arbind/craftoid.git'
gem 'craftoid', path: '/Users/sequoia/code/food-truck/gem/craftoid'

# services
# gem 'koala' # facebook graph
# gem 'twitter'
# gem 'tweetstream'

# utils
gem 'sass'
gem 'haml'
# gem 'hpricot'
gem 'httparty'
gem 'addressable'
gem 'jquery-rails'

# monitoring
gem 'newrelic_rpm'

group :production do
  gem 'thin'
end

# Gems used only for assets not required in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'ruby-debug19'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'autotest'
  gem 'launchy'
  gem 'faker'
  gem 'haml-rails'
  gem 'spork'
end
