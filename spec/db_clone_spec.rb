require 'rails_helper'

module DbClone
  describe DbClone do
    it 'should be able to auto clone' do
      DbClone.config = {
        default_source: 'second_test_mysql',
        default_destination: 'test_mysql',
      }
      ds = DbSelections.new Rails.root.join('config', 'database.yml')
      cb = CmdBuilder.new ds.selections( use_defaults: true )
      expect(cb.get_cmd).to eql("mysqldump --no-create-db --add-drop-table --lock-tables=false --user=other_mysql_usr --password=other_mysql_password --host=other_mysql_host --port=3306 other_mysql_db | mysql --user=fake_mysql_usr --password=fake_mysql_password --host=fake_mysql_host --port=3306 fake_mysql_db")
    end
  end
end
