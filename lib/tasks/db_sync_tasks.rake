namespace :db do
  desc 'syncs a source database to a destination database'
  task sync: :environment do
    DbSync.sync!
  end
end
