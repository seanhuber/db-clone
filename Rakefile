require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'db/clone'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Db::Clone.setup do |config|
  config.database_yml_path            = File.join 'spec', 'sample_database.yml'
  # config.default_source_database      = 'production'
  # config.default_destination_database = 'development'
  # config.default_source_database      = 'uat2'
  # config.default_destination_database = 'test'
end
