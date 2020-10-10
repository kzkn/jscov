require "spec_helper"
require "fileutils"

describe Jscov do
  before do
    Jscov.configuration.reset!
  end

  describe ".configure" do
    example do
      expect(Jscov.enabled?).to eq true
      expect(Jscov.configuration.coverage_report_dir_path).to eq Rails.root.join("tmp/jscov")

      Jscov.configure do |config|
        config.enabled = false
        config.coverage_report_dir_path = Pathname("testing")
      end

      expect(Jscov.enabled?).to eq false
      expect(Jscov.configuration.coverage_report_dir_path).to eq Pathname("testing")
    end
  end

  describe ".clean!" do
    before do
      FileUtils.mkdir_p "testing/subdir"
    end

    after do
      FileUtils.rm_rf "testing"
    end

    example do
      Jscov.configure do |config|
        config.coverage_report_dir_path = Pathname("testing")
      end

      FileUtils.touch("testing/jscov_12345_12345.json")
      FileUtils.touch("testing/jscov_12345_12345.txt")
      FileUtils.touch("testing/subdir/jscov_12345_12345.json")

      expect(File).to be_exist("testing/jscov_12345_12345.json")
      expect(File).to be_exist("testing/jscov_12345_12345.txt")
      expect(File).to be_exist("testing/subdir/jscov_12345_12345.json")

      Jscov.clean!

      expect(File).not_to be_exist("testing/jscov_12345_12345.json")
      expect(File).to be_exist("testing/jscov_12345_12345.txt")
      expect(File).to be_exist("testing/subdir/jscov_12345_12345.json")
    end
  end
end
