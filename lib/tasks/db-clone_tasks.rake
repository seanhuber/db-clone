namespace :db do
  desc 'clones a source database to a destination database'
  task :clone, [:manual] => :environment do |t, args|
    DbClone.clone! manual: args[:manual].present?
  end
end
