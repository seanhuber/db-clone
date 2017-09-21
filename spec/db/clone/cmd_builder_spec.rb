require 'spec_helper'

RSpec.describe Db::Clone::CmdBuilder do
  before(:each) do
    @db_yml = YAML.load_file File.join('spec', 'sample_database.yml')
  end

  it 'generates a mysqldump command piping production into development' do
    Db::Clone.setup do |config|
      config.database_yml_path = File.join 'spec', 'sample_database.yml'
      config.ignore_tables     = []
    end

    cmd_builder = Db::Clone::CmdBuilder.new src: @db_yml['production'], dest: @db_yml['development']

    expect(cmd_builder.cmd).to eq("mysqldump --no-create-db --add-drop-table --lock-tables=false --user=production_user --password=production_pw --host=localhost --port=3306 production_db | mysql --user=dev_user --password=dev_pw --host=localhost --port=3306 dev_db")
  end

  it 'generates a mysqldump command piping production into development with ignore_tables' do
    Db::Clone.setup do |config|
      config.database_yml_path = File.join 'spec', 'sample_database.yml'
      config.ignore_tables     = ['table_a', 'table_b', 'table_c']
    end

    cmd_builder = Db::Clone::CmdBuilder.new src: @db_yml['production'], dest: @db_yml['development']

    expect(cmd_builder.cmd).to eq("mysqldump --no-create-db --add-drop-table --lock-tables=false --user=production_user --password=production_pw --host=localhost --port=3306 --ignore-table=production_db.table_a --ignore-table=production_db.table_b --ignore-table=production_db.table_c production_db | mysql --user=dev_user --password=dev_pw --host=localhost --port=3306 dev_db")
  end

  it 'generates a pg_dump command piping production into development' do
    Db::Clone.setup do |config|
      config.database_yml_path = File.join 'spec', 'sample_database.yml'
    end

    cmd_builder = Db::Clone::CmdBuilder.new src: @db_yml['pg_production'], dest: @db_yml['pg_development']

    expect(cmd_builder.cmd).to eq("pg_dump --no-password --clean --host=localhost --port=5432 --username=pg_prod_user pg_prod_db | psql --host=localhost --port=5432 --username=pg_dev_user pg_dev_db")
  end
end
