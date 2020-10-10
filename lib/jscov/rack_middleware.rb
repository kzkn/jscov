require "rack/request"
require "jscov/coverage"
require "jscov/bless"

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
        response = @app.call(env)
        Bless.new(response).result
      end
    end

    def jscov_request?(request)
      request.request_method == "POST" && request.path == coverages_path
    end

    def coverages_path
      Jscov.configuration.coverages_path
    end

    def handle(request)
      raw_data = JSON.parse(request.params["coverage"])
      coverage = Jscov::Coverage.new(raw_data)
      coverage.save
      [204, {}, []]
    end
  end
end
