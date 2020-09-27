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
  spec.description = "Jscov is a Rails Engine for collecting JavaScript code coverages."
  spec.license = "MIT"

  spec.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "railties", ">= 5.2"
  spec.add_dependency "actionview", ">= 5.2"

  spec.add_development_dependency "sqlite3"
end
