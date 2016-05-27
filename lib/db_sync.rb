require 'colorize'
require 'db_sync/db_selections'
require 'db_sync/engine'

module DbSync
  def self.sync!
    ds = DbSelections.new Rails.root.join('config', 'database.yml')
    [:source_prompt, :source_get, :dest_prompt, :dest_get].each{|m| ds.send(m)}

    # String.colors.each{|str| puts str.to_s.send(str)}
  end
end
