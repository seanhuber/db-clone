desc "Explaining what the task does"
task :db_sync do
  require 'colorize'

  puts "\n  Step 1 of 3: Which database do you wish to clone?"

  # print "\n    Enter a choice: "
  # str = STDIN.gets.chomp
  # puts "\n    Your choice: --#{str}--"

  puts "\n  Step 2 of 3: Which database is the destination for this clone?"

  puts "\n  Step 3 of 3: The following command is about to be executed. Press enter to continue."

  puts "\n  Done.\n\n"

  # puts Rails.root.join('config', 'database.yml')

  db_conf = YAML.load_file Rails.root.join('config', 'database.yml')
  ap db_conf.keys.sort

  db_blocks = db_conf.keys
  puts "\n  Connection blocks defined in #{'config/database.yml'.light_green}:\n\n"
  db_blocks.each_with_index do |x, idx|
    puts "\t[ #{"#{(idx+1).to_s.ljust(db_blocks.length.to_s.length).light_blue}"} ] #{x.yellow}"
  end
  print "\n  Choose a source database (#{'1'.light_blue}-#{db_blocks.length.to_s.light_blue}) [production = 1]: "
end

namespace :db do
  desc "TODO: write a description"
  task :sync do
    DbSync.sync!
  end
end
