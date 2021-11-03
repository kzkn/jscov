$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "jscov/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = "jscov"
  spec.version = Jscov::VERSION
  spec.authors = ["Kazuki Nishikawa"]
  spec.email = ["kzkn@users.noreply.github.com"]
  spec.homepage = "https://github.com/kzkn/jscov"
  spec.summary = "Collect JavaScript code coverages."
  spec.description = "A rack middleware for collecting JavaScript code coverages."
  spec.license = "MIT"

  spec.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rack", ">= 2.0"
  spec.add_dependency "capybara", ">= 3.0"
  spec.add_dependency "selenium-webdriver", ">= 4.0"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webdrivers"
  spec.add_development_dependency "rails", [">= 5.2", "< 7.0"]
end
