module Jscov
  class Coverage
    def initialize(raw_data)
      @raw_data = raw_data
    end

    def save
      File.open(self.class.new_coverage_file_path, "w") do |f|
        f.puts @raw_data.to_json
      end
    end

    class << self
      def new_coverage_file_path
        Jscov.configuration.coverage_report_dir_path.join("jscov_#{Time.current.to_i}_#{SecureRandom.uuid}.json")
      end
    end
  end
end
