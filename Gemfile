source "http://rubygems.org"

gemspec

rails_version = ENV['RAILS_VERSION'] || '>= 0'
rails_version = "~> #{rails_version}" if rails_version =~ /^\d/

gem 'rails', rails_version == 'master' ? { github: 'rails/rails' } : rails_version

if RUBY_VERSION >= '3.0.0'
  gem 'rexml'
  gem 'webrick'
end
