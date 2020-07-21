# frozen_string_literal: true

module TADA
  # status validator by different representations
  class Status
    include Comparable

    # index of corresponding data representation in MAP
    INDEX_STR = 0
    INDEX_SYM = 1 # @see INDEX_STR

    # maps of representations per data type to integer
    CMAP = { '-' => 0, 'x' => 1, '+' => 2 }.freeze
    SMAP = { todo: 0, doing: 1, done: 2 }.freeze # @see CMAP

    # map of integer representation to string and symbol data types
    MAP = [
      ['-', :todo],
      ['x', :doing],
      ['+', :done]
    ].freeze

    # Initialize and convert given +stat+ to different representations
    #
    # @param [String, Symbol, Integer, TADA::Status] stat
    # @raise TypeError
    def initialize(stat)
      # convert given stat to integer based on its data type
      @int_stat = Status.to_i(stat)

      # set string and symbol data reprs by integer MAP
      @sym_stat = MAP[@int_stat][INDEX_SYM]
      @str_stat = MAP[@int_stat][INDEX_STR]
    end

    # convert to string
    #
    # @see MAP
    def to_s
      @str_stat
    end

    # convert to symbol
    #
    # @see SMAP
    def to_sym
      @sym_stat
    end

    # convert to integer
    #
    # @see SMAP
    def to_i
      @int_stat
    end

    # convert different types to integer status
    #
    # @param [String, Symbol, Integer, TADA::Status] stat
    # @raise [TypeError]
    def self.to_i(stat)
      number =
        if stat.is_a?(String) then CMAP.fetch(stat, nil)
        elsif stat.is_a?(Symbol) then SMAP.fetch(stat, nil)
        elsif stat.is_a?(Integer) && (0...(MAP.size)).include?(stat)
          stat
        elsif stat.is_a?(Status) then stat.to_i
        end

      unless number
        raise \
          TypeError,
          'expected Integer, String, Symbol or TADA::Status'
      end

      number
    end

    # comapre by integer represenation.
    #
    # @param [TADA::Status] other
    # @return [-1, 0, 1]
    def <=>(other)
      # compare by integer representation of status
      @int_stat <=> other.to_i
    end
  end
end
