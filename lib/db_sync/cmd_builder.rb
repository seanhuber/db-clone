module DbSync
  class CmdBuilder
    VALID_DB_KEYS = ['host', 'port', 'username', 'database']
    def initialize( selections )
      @src_dest = selections.map{|k,v| [k,v.delete_if{|i,j| !VALID_DB_KEYS.include?(i)}]}.to_h
    end

    def build
      [
        "pg_dump --no-password --clean",
        "--host=#{@src_dest[:src]['host']}",
        "--port=#{@src_dest[:src]['port']}",
        "--username=#{@src_dest[:src]['username']}",
        "#{@src_dest[:src]['database']}",
        "| psql",
        "--host=#{@src_dest[:dest]['host']}",
        "--port=#{@src_dest[:dest]['port']}",
        "--username=#{@src_dest[:dest]['username']}",
        "#{@src_dest[:dest]['database']}"
      ].join(' ')
    end
  end
end
