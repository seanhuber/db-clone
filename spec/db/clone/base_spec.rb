require 'spec_helper'

RSpec.describe Db::Clone::Base do
  before(:each) do
    @db_yml = YAML.load_file File.join('spec', 'sample_database.yml')

    Db::Clone.setup do |config|
      config.database_yml_path = File.join 'spec', 'sample_database.yml'
      config.ignore_tables     = []
    end

    @db_clone = Db::Clone::Base.new

    expect(@db_clone).to receive(:exec).once.and_return nil
    allow(@db_clone).to receive(:puts)
    allow(@db_clone).to receive(:print)
  end

  it 'will clone using defaults' do
    @db_clone.clone! false
  end

  it 'will clone with prompts' do
    expect(STDIN).to receive(:gets).and_return('8', '7')
    @db_clone.clone! true
  end

  it 'will abort if writing to default source' do
    allow(STDIN).to receive(:gets).and_return('2', '4')
    expect(@db_clone).to receive(:abort).once
    @db_clone.clone! true
  end
end
