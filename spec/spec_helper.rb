ENV["RAILS_ENV"] = "test"

require "capybara/rspec"
require "webdrivers"

require "jscov"

Dir[File.expand_path("./apps/*.rb", __dir__)].each do |f|
  require f
end

Capybara.server = :webrick
Capybara.default_driver = :selenium_chrome_headless

TestRailsApp::Application.configure do |app|
  app.middleware.use Jscov::RackMiddleware
end
