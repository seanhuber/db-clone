module Db::Clone
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

      puts "\n\nsource: #{src_db.green}"
      puts "dest: #{dest_db.green}\n\n"

      cmd_builder = CmdBuilder.new src: @db_yml[src_db], dest: @db_yml[dest_db]
      puts cmd_builder.cmd.blue
    end

    private

    def prompt_for_src_and_dest
      databases = @db_yml.keys.sort
      default_src = databases.include?(@default_src) ? @default_src : databases.first

      src_db = prompt 'Which is the source database?', default_src, databases.map{|name| [name, name.yellow]}.to_h
      puts "Source database = #{src_db.green}"

      databases.delete src_db
      default_dest = src_db != @default_dest && databases.include?(@default_dest) ? @default_dest : databases.first

      dest_db = prompt 'Which is the destination database?', default_dest, databases.map{|name| [name, name.yellow]}.to_h
      puts "Destination database = #{dest_db.green}"

      if dest_db == @default_src
        proceed = ask_yes_no "#{'WARNING!'.black.on_yellow} You have selected #{@default_src.green} as your destination database, meaning that db-clone will overwrite it with the contents of your #{src_db.green} database. Do you want to proceed anyway?", false
        unless proceed
          puts "\nCloning #{'canceled'.red}."
          abort
        end
      end

      [src_db, dest_db]
    end

    def default_src_and_dest
      raise ArgumentError.new("Configured default source database, #{@default_src}, does not exist in #{Db::Clone.database_yml_path}") unless @db_yml[@default_src]
      raise ArgumentError.new("Configured default destination database, #{@default_dest}, does not exist in #{Db::Clone.database_yml_path}") unless @db_yml[@default_dest]

      [@default_src, @default_dest]
    end
  end
end
