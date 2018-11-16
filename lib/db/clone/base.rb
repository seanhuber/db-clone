module Db
  module Clone
    class Base
      include CmdPrompt

      def self.clone! invoke_cli
        self.new.clone! invoke_cli
      end

      def initialize
        @db_yml = YAML.load_file Db::Clone.database_yml_path
        raise ArgumentError.new("#{Db::Clone.database_yml_path} does not have at least 2 database blocks.") unless @db_yml.length >= 2

        @default_src = Db::Clone.default_source_database
        @default_dest = Db::Clone.default_destination_database
      end

      def clone! invoke_cli
        src_db, dest_db = invoke_cli ? prompt_for_src_and_dest : default_src_and_dest

        cmd_builder = CmdBuilder.new src: @db_yml[src_db], dest: @db_yml[dest_db]

        frame("Cloning #{src_db} into #{dest_db}") do
          unless !invoke_cli || ask_yes_no("Continue?", default_to_yes: dest_db != @default_src)
            puts fmt("\n{{x}} Cloning canceled.")
            abort
          end

          puts fmt("\n  Executing: {{cyan:#{cmd_builder.cmd}}}\n\n")
          Process.wait spawn(cmd_builder.cmd)
          puts fmt("\n{{v}} Cloning complete!")
        end
      end

      private

      def prompt_for_src_and_dest
        frame('Manual DB Selection') do
          databases = @db_yml.keys

          default_src = databases.include?(@default_src) ? @default_src : databases.first

          src_db = prompt 'Which is the source database?', default_src, databases.map { |name| [name, fmt("{{reset:#{name}}}")] }.to_h

          databases.delete src_db
          default_dest = src_db != @default_dest && databases.include?(@default_dest) ? @default_dest : databases.first

          dest_db = prompt 'Which is the destination database?', default_dest, databases.map {|name| [name, colorize_destination(name)]}.to_h

          if dest_db == @default_src
            puts fmt("{{bold:{{yellow:WARNING!}} You have selected {{green:#{@default_src}}} as your destination database, meaning that db-clone will overwrite it with the contents of your {{green:#{src_db}}} database.}}")
          end

          [src_db, dest_db]
        end
      end

      def default_src_and_dest
        raise ArgumentError.new("Configured default source database, #{@default_src}, does not exist in #{Db::Clone.database_yml_path}") unless @db_yml[@default_src]
        raise ArgumentError.new("Configured default destination database, #{@default_dest}, does not exist in #{Db::Clone.database_yml_path}") unless @db_yml[@default_dest]

        [@default_src, @default_dest]
      end

      def colorize_destination(database_name)
        color = case database_name
                when @default_src
                  'red'
                when @default_dest
                  'green'
                else
                  'yellow'
                end

        fmt("{{#{color}:#{database_name}}}")
      end
    end
  end
end
