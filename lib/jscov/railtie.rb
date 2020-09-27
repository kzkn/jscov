require "jscov/helper"

module Jscov
  class Railtie < ::Rails::Railtie
    initializer "jscov" do
      ActiveSupport.on_load(:action_view) do
        include Helper
      end
    end
  end
end
