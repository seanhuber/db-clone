require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'db/clone/rake_task.rb'

RSpec::Core::RakeTask.new(:spec)
Db::Clone::RakeTask.new.install_tasks

task :default => :spec
