$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bootstrap_builder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bootstrap-builder"
  s.version     = BootstrapBuilder::VERSION
  s.authors     = ["Nikolay Lipovtsev"]
  s.email       = ["n.lipovtsev@gmail.com"]
  s.homepage    = "http://github.com/Nikolay-Lipovtsev/bootstrap-builder"
  s.summary     = "Bootstrap Builder allows to simply generate Bootstrap."
  s.description = "Bootatrap Builder allows you to quickly and easily create basic elements of the Bootstrap."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0"

  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "sass-rails", "~> 4.0"
  s.add_development_dependency "bootstrap-sass", "~> 3.1"
end
