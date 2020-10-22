require_relative "./spec_helper"
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

  it "dump coverage data as console log on page transition" do
    visit "/"
    expect(page).to have_content "this is root"
    execute_script("window.__coverage__ = { dummy: 1 }")

    visit "/hello"
    expect(page).to have_content "this is hello"
    execute_script("window.__coverage__ = { dummy: 2 }")
    execute_script('console.log("this will not be parsed")')

    expect do
      Jscov.save!
    end.to change { Dir.glob("testing/jscov_*.json").size }.by(2)

    files = Dir.glob("testing/jscov_*.json")
    jsons = files.map { |f| File.read(f) }.sort
    expect(JSON.parse(jsons[0])).to eq({ "dummy" => 1 })
    expect(JSON.parse(jsons[1])).to eq({ "dummy" => 2 })
  end
end
