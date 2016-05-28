require 'rails_helper'

module DbSync
  describe CmdBuilder do
    describe 'command builder' do
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

      it 'should be able to generate a dump command' do
        expect(cb.get_cmd).to eql("pg_dump --no-password --clean --host=fake_postgresql_host --port=5432 --username=other_postgresql_user other_postgresql_db | psql --host=fake_postgresql_host --port=5432 --username=fake_postgresql_user fake_postgresql_db")
      end
    end
  end
end
