module TADA
  class Ref
    def initialize(*refs)
      # TODO
    end

    def is_singular()
      @refs.size == 1 and @refs[0].class != Ref
    end

    def to_a()
      @refs
    end

    def head()
      @refs.first
    end

    def rest()
      @refs.drop(1)
    end
  end
end
