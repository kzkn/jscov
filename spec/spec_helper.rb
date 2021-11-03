ENV["RAILS_ENV"] = "test"

require "capybara/rspec"
require "webdrivers"

require "jscov"

Dir[File.expand_path("./apps/*.rb", __dir__)].each do |f|
  require f
end

Capybara.server = :webrick

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.load_selenium

  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:chromeOptions' => {
      args: %w[--headless],
    },
    "goog:loggingPrefs" => {
      browser: "ALL",
    },
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: caps)
end

Capybara.default_driver = :headless_chrome

TestRailsApp::Application.configure do |app|
  app.middleware.use Jscov::RackMiddleware
end
