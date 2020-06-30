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

      STATMAP = [STAT_TODO, STAT_DOING, STAT_DONE]
      STATRMAP = { STAT_TODO => 0, STAT_DOING => 1, STAT_DONE => 2 }

      def self.raw_dump(todo_list)
        todo_list.map do |todo|
          # convert each entry in the list to a hash object
          obj = {
            KEY_STATUS => todo.status.to_s,
            KEY_TITLE  => todo.title,
            KEY_INFO   => todo.info,
          }

          # recurse on each entry by its sublist
          obj[KEY_SUBLIST] = raw_dump(todo.sublist)

          return obj
        end
      end

      def self.load(str)
        # load str by builtin json parser
        # validate the result
        # return the result if valid, otherwise raise an error
      end

      def self.dump(todo_list)
        # raw_dump, then convert to json string
      end
    end
  end
end
