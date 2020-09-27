require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "jscov"

module Dummy
  class Application < Rails::Application
  end
end
