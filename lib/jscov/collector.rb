require "json"
require "jscov/coverage"

module Jscov
  class Collector
    def initialize(session, logs)
      @session = session || Capybara.current_session
      @logs = logs
    end

    def coverages
      return [] unless selenium?

      dump_coverage

      browser_logs
        .map { |log| parse(log.message) }
        .compact
        .map { |cov| Coverage.new(cov) }
    end

    def selenium?
      @session.driver.browser.respond_to?(:logs)
    end

    def dump_coverage
      code = <<~JS
        typeof __jscov_dumpCoverage === 'function' && __jscov_dumpCoverage()
      JS
      @session.execute_script(code)
    end

    def browser_logs
      logs = @session.driver.browser.logs.get(:browser)
      (@logs || []) + logs
    end

    def parse(message)
      json_string = message[/__jscov" (.*)/, 1]
      return if json_string.nil?

      json = JSON.parse(json_string)
      JSON.parse(json)
    rescue JSON::ParserError
      nil
    end
  end
end
