module TADA
  class Status
    include Comparable

    INDEX_STR = 0
    INDEX_SYM = 1

    CMAP = { '-' => 0, 'x' => 1, '+' => 2 }
    SMAP = { todo: 0, doing: 1, done: 2 }
    MAP = [
      ['-', :todo],
      ['x', :doing],
      ['+', :done]
    ]

    def initialize(stat)
      if stat.is_a? String
        @int_stat = CMAP.fetch(stat)

      elsif stat.is_a? Symbol
        @int_stat = SMAP.fetch(stat)

      elsif stat.is_a? Integer and stat >= 0
        @int_stat = stat

      else
        raise TypeError, 'expected Integer, String or Symbol'
      end

      @sym_stat = MAP[@int_stat][INDEX_SYM]
      @str_stat = MAP[@int_stat][INDEX_STR]
    end

    def to_s()
      @str_stat
    end

    def to_sym()
      @sym_stat
    end

    def to_i()
      @int_stat
    end

    def <=>(other)
      @int_stat <=> other.to_i
    end
  end
end
