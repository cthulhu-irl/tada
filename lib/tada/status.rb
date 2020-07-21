# frozen_string_literal: true

module TADA
  # status validator by different representations
  class Status
    include Comparable

    # string and symbol representations,
    # index is numeric representation
    CODES = [['-', :todo], ['x', :doing], ['+', :done]].freeze

    INT2STR = CODES.map(&:first)
    INT2SYM = CODES.map(&:last)
    ANY2INT = CODES.each_with_index.reduce({}) do |acc, (keys, i)|
      acc.merge({ i => i }, keys.to_h { |key| [key, i] })
    end.freeze

    attr_reader :to_i, :to_s, :to_sym

    # Initialize and convert given +stat+ to different representations
    #
    # @param [String, Symbol, Integer, TADA::Status] stat
    # @raise TypeError
    def initialize(stat)
      # convert given stat to integer
      @to_i = Status.to_i(stat)

      # set string and symbol data reprs by integer MAP
      @to_s   = INT2STR.fetch(@to_i)
      @to_sym = INT2SYM.fetch(@to_i)
    end

    # convert different types to integer status
    #
    # @param [String, Symbol, Integer, TADA::Status] stat
    # @raise [TypeError]
    def self.to_i(stat)
      stat = stat.to_i if stat.is_a?(Status)

      ANY2INT.fetch(stat) do
        raise \
          TypeError,
          'expected Integer, String, Symbol or TADA::Status'
      end
    end

    # comapre by integer represenation.
    #
    # @param [TADA::Status] stat
    # @return [-1, 0, 1]
    def <=>(other)
      # compare by integer representation of status
      @to_i <=> other.to_i
    end
  end
end
