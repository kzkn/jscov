require "json"

module Jscov
  class TestHooks
    def initialize(session)
      @session = session
    end

    def after_example!
      return unless selenium?

      dump_coverage

      browser_logs.each do |log|
        coverage = parse(log.message)
        if coverage
          Coverage.new(coverage).save
        end
      end
    end

    def selenium?
      @session.driver.browser.respond_to?(:manage)
    end

    def dump_coverage
      @session.execute_script <<~JS
                                typeof __jscov_dumpCoverage === 'function' && __jscov_dumpCoverage()
                              JS
    end

    def browser_logs
      @session.driver.browser.manage.logs.get(:browser)
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
