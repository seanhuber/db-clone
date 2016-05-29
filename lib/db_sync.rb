require 'colorize'
require 'db_sync/cmd_builder'
require 'db_sync/db_selections'
require 'db_sync/engine'

module DbSync
  mattr_accessor :config

  def self.sync!( **opts )
    DbSync.config ||= {}
    DbSync.config[:ignore_tables] ||= []
    DbSync.config[:default_source] ||= 'production'
    DbSync.config[:default_destination] ||= 'development'

    ds = DbSelections.new Rails.root.join('config', 'database.yml')
    src_dest = if opts[:manual]
      [:source_prompt, :source_get, :dest_prompt, :dest_get].each{|m| ds.send(m)}
      ds.selections
    else
      ds.selections( use_defaults: true )
    end

    cb = CmdBuilder.new src_dest
    puts "\n  Executing: #{cb.get_cmd.light_blue}\n\n"
    cb.exec!
  end
end
