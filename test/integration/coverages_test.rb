require "test_helper"
require "fileutils"
require "json"

module Jscov
  class CoveragesTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
      FileUtils.mkdir_p "testing"
      Jscov.configure do |config|
        config.coverage_report_dir_path = Pathname("testing")
      end
    end

    teardown do
      FileUtils.rm_rf "testing"
    end

    test "post coverages" do
      assert_equal 0, Dir.glob("testing/jscov_*.json").size

      post "/jscov/coverages", params: { coverage: { dummy: 1 }.to_json }

      assert_equal 1, Dir.glob("testing/jscov_*.json").size

      json_file = Dir.glob("testing/jscov_*.json")[0]
      coverage = JSON.parse(File.read(json_file))
      assert_equal({ "dummy" => 1 }, coverage)
    end
  end
end
