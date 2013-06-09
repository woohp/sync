$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sync/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sync"
  s.version     = Sync::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Sync."
  s.description = "TODO: Description of Sync."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"

  s.add_development_dependency "sqlite3"
end
