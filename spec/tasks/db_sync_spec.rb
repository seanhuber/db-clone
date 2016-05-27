require 'rails_helper'

module DbSync
  describe DbSync do
    describe 'db selections' do
      ds = DbSelections.new Rails.root.join('config', 'database.yml')

      it 'should prompt for a source' do
        str = "\n  Choose a \e[0;35;49msource\e[0m database from one of the blocks defined in \e[0;92;49mconfig/database.yml\e[0m:\n\n    [ \e[0;94;49m1\e[0m ] \e[0;33;49mdefault\e[0m\n    [ \e[0;94;49m2\e[0m ] \e[0;33;49mdevelopment\e[0m\n    [ \e[0;94;49m3\e[0m ] \e[0;33;49mproduction\e[0m\n    [ \e[0;94;49m4\e[0m ] \e[0;33;49mtest\e[0m\n\n  Choose a \e[0;35;49msource\e[0m database (\e[0;94;49m1\e[0m-\e[0;94;49m4\e[0m) [production = \e[0;94;49m3\e[0m]: "
        expect { ds.source_prompt }.to output(str).to_stdout
      end

      it 'should set a source' do
        allow(STDIN).to receive(:gets) { '2' }
        str = "\n  \e[0;35;49mSource\e[0m set to: \e[0;33;49mdevelopment\e[0m\n"
        expect { ds.source_get }.to output(str).to_stdout
      end

      # [:source_prompt, :source_get, :dest_prompt, :dest_get].each{|m| ds.send(m)}
      # it 'should set a source' do
      #   allow(STDIN).to receive(:gets) { '2' }
      #   ds.source_prompt
      #   ds.source_get
      #
      #   allow(STDIN).to receive(:gets) { '3' }
      #   ds.dest_prompt
      #   ds.dest_get
      # end
    end
  end
end
