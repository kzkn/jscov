require "test_helper"

class Jscov::Coverage::Test < ActiveSupport::TestCase
  setup do
    Jscov.configuration.reset!
  end

  test "new_coverage_file_path" do
    Jscov.configure do |config|
      config.coverage_report_dir_path = Pathname("testing")
    end

    assert_match %r{^testing/jscov_.*_.*\.json$}, Jscov::Coverage.new_coverage_file_path.to_s
  end
end
