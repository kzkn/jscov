require "jscov"

RSpec.configure do |config|
  config.before(:suite) do
    Jscov.clean!
  end
end
