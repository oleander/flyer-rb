$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "flyer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flyer"
  s.version     = Flyer::VERSION
  s.authors     = ["Linus Oleander"]
  s.email       = ["linus@oleander.nu"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Flyer."
  s.description = "TODO: Description of Flyer."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "timecop"
end
