require 'colorize'
require 'db_sync/engine'
require 'db_sync/sync'

module DbSync
  def self.sync!
    sync = Sync.new
    sync.source_prompt
    sync.source_get
    sync.dest_prompt
    sync.dest_get
  end
end
