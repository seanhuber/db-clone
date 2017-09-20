module Db
  module Clone
    class Base
      def self.clone! invoke_cli
        puts "Should I start the cli? #{invoke_cli}"
      end
    end
  end
end
