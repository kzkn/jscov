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

  if Selenium::WebDriver::VERSION < "4.0.0"
    setup_selenium_driver_3x
  else
    setup_selenium_driver
  end
end

def setup_selenium_driver_3x
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[headless],
      # required for Chrome 75+
      w3c: false,
    },
    # For up to Chrome 74
    loggingPrefs: {
      browser: "ALL",
    },
    # for Chrome 75+
    "goog:loggingPrefs" => {
      browser: "ALL",
    },
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: caps)
end

def setup_selenium_driver
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:chromeOptions" => {
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
