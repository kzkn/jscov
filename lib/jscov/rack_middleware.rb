require "rack/request"
require "jscov/coverage"

module Jscov
  class RackMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = ::Rack::Request.new(env)
      if jscov_request?(request)
        handle(request)
      else
        @app.call(env)
      end
    end

    def jscov_request?(request)
      request.request_method == "POST" && request.path == "/jscov/coverages"
    end

    def handle(request)
      raw_data = JSON.parse(request.params["coverage"])
      coverage = Jscov::Coverage.new(raw_data)
      coverage.save
      [204, {}, []]
    end
  end
end
