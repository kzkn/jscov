require "securerandom"
require "jscov/configuration"
require "jscov/rack_middleware"
require "jscov/collector"

module Jscov
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def clean!
      dir_path = configuration.coverage_report_dir_path
      FileUtils.rm_f(Dir.glob(dir_path.join("jscov_*.json")))
      FileUtils.mkdir_p(dir_path)
    end

    def save!(session: nil, logs: nil)
      collector = Collector.new(session, logs)
      collector.coverages.each(&:save)
    end
  end
end
