module Db::Clone
  class RakeTask
    include Rake::DSL if defined? Rake::DSL

    def install_tasks
      return unless defined? namespace

      namespace :db do
        desc 'clones a source database to a destination database'
        task :clone, [:manual] => :environment do |t, args|
          invoke_cli = !args[:manual].nil?
          Db::Clone::Base.clone! invoke_cli
        end
      end
    end
  end
end
