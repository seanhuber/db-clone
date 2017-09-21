module Db::Clone
  class CmdBuilder
    VALID_DB_KEYS = ['host', 'port', 'username', 'database', 'password']
    SUPPORTED_DBS = [:mysql, :postgresql]

    attr_reader :cmd

    def initialize selections
      raise ArgumentError.new('Both source and destination must be set') unless selections[:src] && selections[:dest]
      raise ArgumentError.new('Source and destination databases must be of the same type') unless selections[:src]['adapter'] == selections[:dest]['adapter']
      SUPPORTED_DBS.each{|db| @db_type = db if selections[:src]['adapter'].include?(db.to_s)}
      raise ArgumentError.new("Unsupported database: #{selections[:src]['adapter']}") unless @db_type
      src_dest = selections.map{|k,v| [k,v.delete_if{|i,j| !VALID_DB_KEYS.include?(i)}]}.to_h
      @cmd = send "build_#{@db_type}_cmd", src_dest
    end

    private

    def build_mysql_cmd src_dest
      mysqldump_args = [
        "mysqldump --no-create-db --add-drop-table --lock-tables=false",
        "--user=#{src_dest[:src]['username']}",
        "--password=#{src_dest[:src]['password']}",
        "--host=#{src_dest[:src]['host']}",
        "--port=#{src_dest[:src]['port']}"
      ]

      Db::Clone.ignore_tables.each{|tbl| mysqldump_args << "--ignore-table=#{src_dest[:src]['database']}.#{tbl}"}

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
      [
        "pg_dump --no-password --clean",
        "--host=#{src_dest[:src]['host']}",
        "--port=#{src_dest[:src]['port']}",
        "--username=#{src_dest[:src]['username']}",
        "#{src_dest[:src]['database']}",
        "| psql",
        "--host=#{src_dest[:dest]['host']}",
        "--port=#{src_dest[:dest]['port']}",
        "--username=#{src_dest[:dest]['username']}",
        "#{src_dest[:dest]['database']}"
      ].join(' ')
    end
  end
end
