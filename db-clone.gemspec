$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'db_clone/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'db-clone'
  s.version     = DbClone::VERSION
  s.authors     = ['Sean Huber']
  s.email       = ['seanhuber@seanhuber.com']
  s.homepage    = 'https://github.com/seanhuber/db-clone'
  s.summary     = 'rake db:clone will clone your production database to development'
  s.description = 'rake db:clone[manual] provides a CLI for selecting a specific source database to copy to a specific destination database. Supports postgreql and mysql.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.required_ruby_version = '>= 2.1'

  s.add_dependency 'rails', '>= 4.0'
  s.add_dependency 'colorize', '~> 0.7'

  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'awesome_print', '~> 1.6'

  s.add_development_dependency 'rspec-rails', '~> 3.4'
end
