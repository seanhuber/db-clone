module Db
  module Clone
    class RakeTask
      include Rake::DSL if defined? Rake::DSL

      def install_tasks
        return unless defined? namespace
        
        namespace :db do
          desc 'clones a source database to a destination database'
          task :clone, [:manual] do |t, args|
            puts 'hello world'
          end
        end
      end
    end
  end
end
