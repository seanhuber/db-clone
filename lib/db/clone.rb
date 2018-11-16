require 'yaml'

require 'db/clone/cmd_builder.rb'
require 'db/clone/cmd_prompt.rb'
require 'db/clone/base.rb'
require 'db/clone/rake_task.rb'
require 'db/clone/version'

Db::Clone::RakeTask.new.install_tasks

module Db
  module Clone
    @@database_yml_path = File.join 'config', 'database.yml'
    def self.database_yml_path
      @@database_yml_path
    end
    def self.database_yml_path=(database_yml_path)
      @@database_yml_path = database_yml_path
    end

    @@default_source_database = 'production'
    def self.default_source_database
      @@default_source_database
    end
    def self.default_source_database=(default_source_database)
      @@default_source_database = default_source_database
    end

    @@default_destination_database = 'development'
    def self.default_destination_database
      @@default_destination_database
    end
    def self.default_destination_database=(default_destination_database)
      @@default_destination_database = default_destination_database
    end

    @@ignore_tables = []
    def self.ignore_tables
      @@ignore_tables
    end
    def self.ignore_tables=(ignore_tables)
      @@ignore_tables = ignore_tables
    end

    def self.setup
      yield self
    end
  end
end
