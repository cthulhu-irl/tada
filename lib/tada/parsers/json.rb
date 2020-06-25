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

      def self.raw_dump(todo_list)
        # convert each entry in the list to a hash object
        # recurse on each entry by its sublist if sublist isn't empty
        # return the result
      end

      def self.load(str)
        # load str by builtin json parser
        # validate the result
        # return the result if valid, otherwise raise an error
      end

      def self.dump(todo_list)
        # call self.raw_dump with given list to get a raw dump
        # convert the raw dump to json string and return
      end
    end
  end
end
