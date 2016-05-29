$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'db_sync/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'db_sync'
  s.version     = DbSync::VERSION
  s.authors     = ['Sean Huber']
  s.email       = ['seanhuber@seanhuber.com']
  s.homepage    = 'https://github.com/seanhuber/db-sync'
  s.summary     = 'rake db:sync will clone your production database to development'
  s.description = 'rake db:sync[manual] provides a CLI for selecting a specific source database to copy to a specific destination database. Supports postgreql and mysql.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.2.6'
  s.add_dependency 'colorize'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'awesome_print'

  s.add_development_dependency 'rspec-rails'
  # s.add_development_dependency 'factory_girl_rails'
end
