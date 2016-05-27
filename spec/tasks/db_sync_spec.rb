require 'rails_helper'

module DbSync
  describe DbSync do
    describe 'db selections' do
      ds = DbSelections.new Rails.root.join('config', 'database.yml')

      it 'should prompt for a source' do
        str = "\n  Choose a \e[0;35;49msource\e[0m database from one of the blocks defined in \e[0;92;49mconfig/database.yml\e[0m:\n\n    [ \e[0;94;49m1\e[0m ] \e[0;33;49mdefault\e[0m\n    [ \e[0;94;49m2\e[0m ] \e[0;33;49mdevelopment\e[0m\n    [ \e[0;94;49m3\e[0m ] \e[0;33;49mproduction\e[0m\n    [ \e[0;94;49m4\e[0m ] \e[0;33;49msecond_test_mysql\e[0m\n    [ \e[0;94;49m5\e[0m ] \e[0;33;49msecond_test_postgresql\e[0m\n    [ \e[0;94;49m6\e[0m ] \e[0;33;49mtest\e[0m\n    [ \e[0;94;49m7\e[0m ] \e[0;33;49mtest_mysql\e[0m\n    [ \e[0;94;49m8\e[0m ] \e[0;33;49mtest_postgresql\e[0m\n\n  Choose a \e[0;35;49msource\e[0m database (\e[0;94;49m1\e[0m-\e[0;94;49m8\e[0m) [production = \e[0;94;49m3\e[0m]: "
        expect { ds.source_prompt }.to output(str).to_stdout
      end

      it 'should set a source' do
        allow(STDIN).to receive(:gets) { '5' }
        str = "\n  \e[0;35;49mSource\e[0m set to: \e[0;33;49msecond_test_postgresql\e[0m\n"
        expect { ds.source_get }.to output(str).to_stdout
      end

      it 'should prompt for a destination' do
        str = "\n  Choose a \e[0;35;49mdestination\e[0m database from one of the blocks defined in \e[0;92;49mconfig/database.yml\e[0m:\n\n    [ \e[0;94;49m1\e[0m ] \e[0;33;49mdefault\e[0m\n    [ \e[0;94;49m2\e[0m ] \e[0;33;49mdevelopment\e[0m\n    [ \e[0;94;49m3\e[0m ] \e[0;33;49mproduction\e[0m\n    [ \e[0;94;49m4\e[0m ] \e[0;33;49msecond_test_mysql\e[0m\n    [ \e[0;31;49mX\e[0m ] \e[0;31;49msecond_test_postgresql\e[0m\n    [ \e[0;94;49m6\e[0m ] \e[0;33;49mtest\e[0m\n    [ \e[0;94;49m7\e[0m ] \e[0;33;49mtest_mysql\e[0m\n    [ \e[0;94;49m8\e[0m ] \e[0;33;49mtest_postgresql\e[0m\n\n  Choose a \e[0;35;49mdestination\e[0m database (\e[0;94;49m1\e[0m-\e[0;94;49m8\e[0m) [development = \e[0;94;49m2\e[0m]: "
        expect { ds.dest_prompt }.to output(str).to_stdout
      end

      it 'should set a destination' do
        allow(STDIN).to receive(:gets) { '8' }
        str = "\n  \e[0;35;49mDestination\e[0m set to: \e[0;33;49mtest_postgresql\e[0m\n"
        expect { ds.dest_get }.to output(str).to_stdout
      end

      it 'should have a source and destination set' do
        expected_selections = {
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
        expect(ds.selections).to eql(expected_selections)
      end
    end
  end
end
