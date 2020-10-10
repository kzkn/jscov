require "spec_helper"
require "fileutils"
require "json"

RSpec.describe "jscov rack middleware", type: :feature do
  before do
    Capybara.app = TestRailsApp::Application

    FileUtils.mkdir_p "testing"
    Jscov.configure do |config|
      config.coverage_report_dir_path = Pathname("testing")
    end
  end

  after do
    FileUtils.rm_rf "testing"
  end

  it "sends coverage data on page transition" do
    visit "/"
    expect(page).to have_content "this is root"
    expect(Dir.glob("testing/jscov_*.json").size).to eq 0

    visit "/hello"
    expect(page).to have_content "this is hello"
    expect(Dir.glob("testing/jscov_*.json").size).to eq 1

    json_file = Dir.glob("testing/jscov_*.json")[0]
    coverage = JSON.parse(File.read(json_file))
    expect(coverage).to eq({ "dummy" => 1 })
  end
end
