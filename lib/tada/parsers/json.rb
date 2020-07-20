# frozen_string_literal: true

require 'tada/todo'

module TADA
  module Parsers
    # json serializer/deserializer for todo list
    class JSONParser
      KEY_STATUS  = 'status' # internal
      KEY_TITLE   = 'title' # internal
      KEY_INFO    = 'info' # internal
      KEY_SUBLIST = 'sublist' # internal

      STAT_TODO  = 'todo' # internal
      STAT_DOING = 'doing' # internal
      STAT_DONE  = 'done' # internal

      # integer status to internal string status conversion map
      STATMAP = [STAT_TODO, STAT_DOING, STAT_DONE].freeze

      # internal string status to integer string status conversion map
      STATRMAP =
        { STAT_TODO => 0, STAT_DOING => 1, STAT_DONE => 2 }.freeze

      # Convert a json compatible representation of todo list array
      # to a todo list with TADA::TODO instances.
      #
      # @param [Array<Hash>] raw_todo_list
      # @return [Array<TADA::TODO>]
      def self.raw_load(raw_todo_list)
        raw_todo_list.map do |raw_todo|
          status  = STATRMAP[raw_todo[KEY_STATUS]]
          title   = raw_todo[KEY_TITLE]
          info    = raw_todo[KEY_INFO]
          sublist = raw_load(raw_todo[KEY_SUBLIST])

          TADA::TODO.new(status, title, info: info, sublist: sublist)
        end
      end

      # Convert TADA::TODO instances to a serializable form.
      #
      # @param [Array<TADA::TODO>] todo_list
      # @return [Hash] json compatible representation of +todo_list+
      def self.raw_dump(todo_list)
        todo_list.map do |todo|
          # convert each entry in the list to a hash object
          obj = {
            KEY_STATUS => STATMAP[todo.status.to_i],
            KEY_TITLE => todo.title,
            KEY_INFO => todo.info
          }

          # recurse on each entry by its sublist
          obj[KEY_SUBLIST] = raw_dump(todo.sublist)

          obj
        end
      end

      # Convert given string to a todo list array.
      #
      # @param [String] str
      # @return [Array<TADA::TODO>]
      def self.load(str)
        # load str by builtin json parser, then convert
        raw_load(JSON.parse(str))
      end

      # Convert given +todo_list+ to a json string.
      #
      # @param [Array<TADA::TODO>] todo_list
      # @return [String] json string.
      def self.dump(todo_list)
        # raw_dump, then convert to json string
        JSON.pretty_generate(raw_dump(todo_list))
      end
    end
  end
end
