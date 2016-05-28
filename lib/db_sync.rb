require 'colorize'
require 'db_sync/cmd_builder'
require 'db_sync/db_selections'
require 'db_sync/engine'

module DbSync
  def self.sync!
    ds = DbSelections.new Rails.root.join('config', 'database.yml')
    [:source_prompt, :source_get, :dest_prompt, :dest_get].each{|m| ds.send(m)}
    h = ds.selections

    h = {
      src: {
        'adapter'  => 'postgresql',
        'encoding' => 'unicode',
        'database' => 'other_postgresql_db',
        'username' => 'other_postgresql_user',
        'password' => 'other_postgresql_password',
        'host'     => 'fake_postgresql_host',
        'port'     => 5432,
        :label     => 'second_test_postgresql'
      },
      dest: {
        'adapter'  => 'postgresql',
        'encoding' => 'unicode',
        'database' => 'fake_postgresql_db',
        'username' => 'fake_postgresql_user',
        'password' => 'fake_postgresql_password',
        'host'     => 'fake_postgresql_host',
        'port'     => 5432,
        :label     => 'test_postgresql'
      }
    }
    cb = CmdBuilder.new h
    puts "\n  Executing: #{cb.get_cmd.light_blue}\n\n"
    # cb.exec!

    # String.colors.each{|str| puts str.to_s.send(str)}
  end
end
