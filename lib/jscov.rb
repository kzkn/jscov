require "securerandom"
# require "jscov/engine"
require "jscov/configuration"
require "jscov/rack_middleware"

module Jscov
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def enabled?
      configuration.enabled?
    end

    def clean!
      dir_path = configuration.coverage_report_dir_path
      FileUtils.rm_f(Dir.glob(dir_path.join("jscov_*.json")))
      FileUtils.mkdir_p(dir_path)
    end
  end
end
