module Jscov
  class Configuration
    attr_accessor :enabled, :coverage_report_dir_path, :coverages_path

    def initialize
      reset!
    end

    alias enabled? enabled

    def reset!
      self.enabled = Rails.env.test?
      self.coverage_report_dir_path = Rails.root.join("tmp/jscov")
      self.coverages_path = "/jscov/coverages"
    end
  end
end
