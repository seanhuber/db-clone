require 'yaml'

module DbClone
  class DbSelections
    # read database blocks from config/database.yml
    def initialize( database_yml )
      h = YAML.load_file database_yml
      @dbs = h.sort_by{|k,v| k}.map{|k,v| v.merge(label: k)}
      @default_src_idx = @dbs.find_index{|db| db[:label] == DbClone.config[:default_source]}
      @default_dest_idx = @dbs.find_index{|db| db[:label] == DbClone.config[:default_destination]}
      @selections = {src: nil, dest: nil}
    end

    # STEP 1: prompt user for which database block to use as the source
    def source_prompt
      db_prompt 'source'
    end

    # STEP 2: retrieve from use which database block to use as the source
    def source_get
      db_select 'source'
    end

    # STEP 3: prompt user for which database block to use as the destination
    def dest_prompt
      db_prompt 'destination'
    end

    # STEP 4: retrieve from use which database block to use as the destination
    def dest_get
      db_select 'destination'
    end

    def selections( **opts )
      opts[:use_defaults] ? {src: @dbs[@default_src_idx], dest: @dbs[@default_dest_idx]} : @selections.map{|k,v| [k, v.nil? ? nil : @dbs[v]] }.to_h
    end

    private

    def db_prompt( src_dest )
      num_dbs = @dbs.length
      puts "\n  Choose a #{src_dest.magenta} database from one of the blocks defined in #{'config/database.yml'.light_green}:\n\n"
      @dbs.each_with_index do |db, idx|
        if src_dest == 'destination' && idx == @selections[:src]
          puts "    [ #{"#{'X'.ljust(num_dbs.to_s.length).red}"} ] #{db[:label].red}"
        else
          puts "    [ #{"#{(idx+1).to_s.ljust(num_dbs.to_s.length).light_blue}"} ] #{db[:label].yellow}"
        end
      end
      default = src_dest=='source' ? "#{@dbs[@default_src_idx][:label]} = #{(@default_src_idx+1).to_s.light_blue}" : "#{@dbs[@default_dest_idx][:label]} = #{(@default_dest_idx+1).to_s.light_blue}"
      print "\n  Choose a #{src_dest.magenta} database (#{'1'.light_blue}-#{num_dbs.to_s.light_blue}) [#{default}]: "
    end

    def db_select( src_dest )
      sk = src_dest=='source' ? :src : :dest
      idx = STDIN.gets.chomp
      idx = ((src_dest=='source' ? @default_src_idx : @default_dest_idx)+1).to_s if idx == ''
      raise(ArgumentError, "Invalid selection: #{src_idx}") unless (1..@dbs.length).map(&:to_s).include?(idx)
      @selections[sk] = idx.to_i - 1
      raise(ArgumentError, 'Destination cannot be the same as the source') unless @selections.values.uniq.length == 2
      raise(ArgumentError, 'Source and destination databases must be of the same type') if src_dest=='destination' && @dbs[@selections[:src]]['adapter'] != @dbs[@selections[:dest]]['adapter']
      puts "\n  #{src_dest.capitalize.magenta} set to: #{@dbs[@selections[sk]][:label].yellow}"
    end
  end
end
