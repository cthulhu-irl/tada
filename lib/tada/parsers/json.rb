module TADA
  module Parsers
    class JSONParser
      KEY_STATUS  = 'status'
      KEY_TITLE   = 'title'
      KEY_INFO    = 'info'
      KEY_SUBLIST = 'sublist'

      STAT_TODO  = 'todo'
      STAT_DOING = 'doing'
      STAT_DONE  = 'done'

      def self.load(str)
      end

      def self.dump(todo_list)
      end
    end
  end
end
