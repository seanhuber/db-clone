require 'spec_helper'

RSpec.describe Db::Clone do
  it 'has a version number' do
    expect(Db::Clone::VERSION).not_to be nil
  end

  it 'is configurable' do
    Db::Clone.setup do |config|
      config.database_yml_path            = File.join 'spec', 'sample_database.yml'
      config.default_source_database      = 'uat'
      config.default_destination_database = 'test'
      config.ignore_tables                = ['first_ignore', 'second_ignore']
    end

    expect(Db::Clone.database_yml_path).to eq(File.join 'spec', 'sample_database.yml')
    expect(Db::Clone.default_source_database).to eq('uat')
    expect(Db::Clone.default_destination_database).to eq('test')
    expect(Db::Clone.ignore_tables).to eq(['first_ignore', 'second_ignore'])
  end
end
