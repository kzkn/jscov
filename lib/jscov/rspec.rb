require 'capybara'
require "jscov"
require "jscov/test_hooks"

RSpec.configure do |config|
  config.before(:suite) do
    Jscov.clean!
  end

  %i[system feature].each do |type|
    config.after(type: type) do
      Jscov::TestHooks.new(Capybara.current_session).after_example!
    end
  end
end
