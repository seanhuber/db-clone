require 'rails_helper'

module DbClone
  describe CmdBuilder do
    describe 'postgresql command builder' do
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

      it 'should be able to generate a pg_dump command' do
        expect(cb.get_cmd).to eql("pg_dump --no-password --clean --host=fake_postgresql_host --port=5432 --username=other_postgresql_user other_postgresql_db | psql --host=fake_postgresql_host --port=5432 --username=fake_postgresql_user fake_postgresql_db")
      end
    end

    describe 'mysql command builder' do
      before(:each) do
        @h = {
         :src => {
             'adapter' => 'mysql2',
            'database' => 'fake_mysql_db',
            'username' => 'fake_mysql_usr',
            'password' => 'fake_mysql_password',
                'host' => 'fake_mysql_host',
                'port' => 3306,
                :label => 'test_mysql'
          },
          :dest => {
               'adapter' => 'mysql2',
              'database' => 'other_mysql_db',
              'username' => 'other_mysql_usr',
              'password' => 'other_mysql_password',
                  'host' => 'other_mysql_host',
                  'port' => 3306,
                  :label => 'second_test_mysql'
          }
        }
      end

      it 'should be able to generate a mysqldump command' do
        cb = CmdBuilder.new @h
        expect(cb.get_cmd).to eql("mysqldump --no-create-db --add-drop-table --lock-tables=false --user=fake_mysql_usr --password=fake_mysql_password --host=fake_mysql_host --port=3306 fake_mysql_db | mysql --user=other_mysql_usr --password=other_mysql_password --host=other_mysql_host --port=3306 other_mysql_db")
      end

      it 'should be able to generate a mysqldump command with ignore tables' do
        DbClone.config = {
          ignore_tables: ['tableAAAA', 'tableBBBB', 'tableCCCC']
        }
        cb = CmdBuilder.new @h
        expect(cb.get_cmd).to eql("mysqldump --no-create-db --add-drop-table --lock-tables=false --user=fake_mysql_usr --password=fake_mysql_password --host=fake_mysql_host --port=3306 --ignore-table=fake_mysql_db.tableAAAA --ignore-table=fake_mysql_db.tableBBBB --ignore-table=fake_mysql_db.tableCCCC fake_mysql_db | mysql --user=other_mysql_usr --password=other_mysql_password --host=other_mysql_host --port=3306 other_mysql_db")
      end
    end
  end
end
