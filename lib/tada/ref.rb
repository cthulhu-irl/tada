module TADA
  class Ref
    def initialize(*refs)
      # flatten the refs
      # check each ref has a valid type
        # if ref is a Ref, replace it by its to_a
        # if ref is a String, parse it and replace by its to_a
      # flatten the refs and save
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
