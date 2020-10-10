require "securerandom"
require "jscov/engine"
require "jscov/railtie"
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

    delegate :enabled?, to: :configuration

    def new_coverage_file_path
      configuration.coverage_report_dir_path.join("jscov_#{Time.current.to_i}_#{SecureRandom.uuid}.json")
    end

    def clean!
      dir_path = configuration.coverage_report_dir_path
      FileUtils.rm_f(Dir.glob(dir_path.join("jscov_*.json")))
      FileUtils.mkdir_p(dir_path)
    end
  end
end
