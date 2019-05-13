module DbClone
  class CmdBuilder
    VALID_DB_KEYS = ['host', 'port', 'username', 'database', 'password']
    SUPPORTED_DBS = [:mysql, :postgresql]

    def exec!() exec @cmd end

    def initialize( selections )
      raise(ArgumentError, 'Both source and destination must be set') unless selections[:src] && selections[:dest]
      raise(ArgumentError, 'Source and destination databases must be of the same type') unless selections[:src]['adapter'] == selections[:dest]['adapter']
      SUPPORTED_DBS.each{|db| @db_type = db if selections[:src]['adapter'].include?(db.to_s)}
      raise(ArgumentError, "Unsupported database: #{selections[:src]['adapter']}") unless @db_type
      src_dest = selections.map{|k,v| [k,v.delete_if{|i,j| !VALID_DB_KEYS.include?(i)}]}.to_h
      @cmd = send("build_#{@db_type}_cmd", src_dest)
    end

    def get_cmd() @cmd end

    private

    def eval_fields(db)
      db.each_with_object({}) do |(k,v), hsh|
        matched = v.to_s.match(/\A<%=(.+)%>\z/)
        if matched
          hsh[k] = matched[1..-1].map{|s| eval(s).to_s.squish}.join('')
        else
          hsh[k] = v
        end
      end
    end

    def build_mysql_cmd( src_dest )
      mysqldump_args = [
        "mysqldump --no-create-db --add-drop-table --lock-tables=false",
        "--user=#{src_dest[:src]['username']}",
        "--password=#{src_dest[:src]['password']}",
        "--host=#{src_dest[:src]['host']}",
        "--port=#{src_dest[:src]['port']}"
      ]

      DbClone.config[:ignore_tables].each{|tbl| mysqldump_args << "--ignore-table=#{src_dest[:src]['database']}.#{tbl}"} if DbClone.config && DbClone.config[:ignore_tables].is_a?(Array)

      (mysqldump_args + [
        "#{src_dest[:src]['database']}",
        "| mysql",
        "--user=#{src_dest[:dest]['username']}",
        "--password=#{src_dest[:dest]['password']}",
        "--host=#{src_dest[:dest]['host']}",
        "--port=#{src_dest[:dest]['port']}",
        "#{src_dest[:dest]['database']}"
      ]).join(' ')
    end

    def build_postgresql_cmd src_dest
      pg_dump_args = [
        "pg_dump --no-password --clean",
        "--host=#{src_dest[:src]['host']}",
        "--port=#{src_dest[:src]['port']}",
        "--username=#{src_dest[:src]['username']}",
      ]

      Db::Clone.ignore_tables.each{|tbl| pg_dump_args << "--exclude-table=#{tbl}"}

      psql_args = [
        "#{src_dest[:src]['database']}",
        "| psql",
        "--host=#{src_dest[:dest]['host']}",
        "--port=#{src_dest[:dest]['port']}"
      ]

      psql_args << "--username=#{src_dest[:dest]['username']}" if src_dest[:dest]['username'].present?

      psql_args << "#{src_dest[:dest]['database']}"

      (pg_dump_args + psql_args).join(' ')
    end
  end
end
