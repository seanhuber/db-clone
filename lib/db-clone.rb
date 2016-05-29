require 'colorize'
require 'db-clone/cmd_builder'
require 'db-clone/db_selections'
require 'db-clone/engine'

module DbClone
  mattr_accessor :config

  def self.clone!( **opts )
    DbClone.config ||= {}
    DbClone.config[:ignore_tables] ||= []
    DbClone.config[:default_source] ||= 'production'
    DbClone.config[:default_destination] ||= 'development'

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
