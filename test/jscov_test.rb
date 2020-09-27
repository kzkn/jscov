require "test_helper"
require "fileutils"

class Jscov::Test < ActiveSupport::TestCase
  setup do
    Jscov.configuration.reset!
  end

  test "configure" do
    assert_equal true, Jscov.enabled?
    assert_equal Rails.root.join("tmp/jscov"), Jscov.configuration.coverage_report_dir_path

    Jscov.configure do |config|
      config.enabled = false
      config.coverage_report_dir_path = Pathname("testing")
    end

    assert_equal false, Jscov.enabled?
    assert_equal Pathname("testing"), Jscov.configuration.coverage_report_dir_path
  end

  test "new_coverage_file_path" do
    Jscov.configure do |config|
      config.coverage_report_dir_path = Pathname("testing")
    end

    assert_match %r{^testing/jscov_.*_.*\.json$}, Jscov.new_coverage_file_path.to_s
  end

  test "clean!" do
    FileUtils.mkdir_p "testing/subdir"

    Jscov.configure do |config|
      config.coverage_report_dir_path = Pathname("testing")
    end

    FileUtils.touch("testing/jscov_12345_12345.json")
    FileUtils.touch("testing/jscov_12345_12345.txt")
    FileUtils.touch("testing/subdir/jscov_12345_12345.json")

    assert_equal true, File.exist?("testing/jscov_12345_12345.json")
    assert_equal true, File.exist?("testing/jscov_12345_12345.txt")
    assert_equal true, File.exist?("testing/subdir/jscov_12345_12345.json")

    Jscov.clean!

    assert_equal false, File.exist?("testing/jscov_12345_12345.json")
    assert_equal true, File.exist?("testing/jscov_12345_12345.txt")
    assert_equal true, File.exist?("testing/subdir/jscov_12345_12345.json")
  ensure
    FileUtils.rm_rf "testing"
  end
end
