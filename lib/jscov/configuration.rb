module Jscov
  class Configuration
    attr_accessor :coverage_report_dir_path, :coverages_path

    def initialize
      reset!
    end

    def reset!
      self.coverage_report_dir_path = self.class.default_coverage_report_dir_path
      self.coverages_path = "/jscov/coverages"
    end

    class << self
      def default_coverage_report_dir_path
        if defined?(Rails)
          Rails.root.join("tmp/jscov")
        else
          "tmp/jscov"
        end
      end
    end
  end
end
