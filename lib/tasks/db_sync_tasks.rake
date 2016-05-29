namespace :db do
  desc 'syncs a source database to a destination database'
  task :sync, [:manual] => :environment do |t, args|
    DbSync.sync! manual: args[:manual].present?
  end
end
