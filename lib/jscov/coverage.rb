module Jscov
  class Coverage
    def initialize(raw_data)
      @raw_data = raw_data
    end

    def save
      File.open(Jscov.new_coverage_file_path, "w") do |f|
        f.puts @raw_data.to_json
      end
    end
  end
end
