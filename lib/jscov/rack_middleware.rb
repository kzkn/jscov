require "rack/request"
require "jscov/coverage"
require "jscov/bless"

module Jscov
  class RackMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      response = @app.call(env)
      Bless.new(response).result
    end
  end
end
