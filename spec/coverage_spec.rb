require "spec_helper"

describe Jscov::Coverage do
  before do
    Jscov.configuration.reset!
  end

  describe ".new_coverage_file_path" do
    example do
      Jscov.configure do |config|
        config.coverage_report_dir_path = Pathname("testing")
      end

      new_file_path = Jscov::Coverage.new_coverage_file_path
      expect(new_file_path.to_s).to be_match %r{^testing/jscov_.*_.*\.json$}
    end
  end
end
