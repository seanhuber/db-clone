$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'db_sync/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'db_sync'
  s.version     = DbSync::VERSION
  s.authors     = ['Sean Huber']
  s.email       = ['seanhuber@seanhuber.com']
  s.homepage    = 'http://seanhuber.com'
  s.summary     = 'Summary of DbSync.'
  s.description = 'Description of DbSync.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 4.2.6'
  s.add_dependency 'colorize'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'awesome_print'
end
