require 'db/clone/base.rb'
require 'db/clone/rake_task.rb'
require 'db/clone/version'

Db::Clone::RakeTask.new.install_tasks
