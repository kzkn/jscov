require_relative "./spec_helper"
require "fileutils"
require "json"
require 'jscov/test_hooks'

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
    execute_script('window.__coverage__ = { dummy: 1 }')

    visit "/hello"
    expect(page).to have_content "this is hello"
    execute_script('window.__coverage__ = { dummy: 2 }')
    execute_script('console.log("this will be not parsed")')

    expect do
      Jscov::TestHooks.new(Capybara.current_session).after_example!
    end.to change { Dir.glob("testing/jscov_*.json").size }.by(2)

    files = Dir.glob("testing/jscov_*.json")
    json_file = files[0]
    coverage = JSON.parse(File.read(json_file))
    expect(coverage).to eq({ "dummy" => 1 })

    json_file = files[1]
    coverage = JSON.parse(File.read(json_file))
    expect(coverage).to eq({ "dummy" => 2 })
  end
end
