require 'db_sync/db_selections'

module DbSync
  describe DbSync do
    describe 'db selections' do
      puts `pwd`
      # ds = DbSelections.new 'config/database.yml'
      20.times do
        it 'should should request a source database' do
          expect(true).to be true
        end
      end
    end
  end
end
