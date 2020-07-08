module TADA
  # nested reference to point at several todos
  class Ref
    # Make a reference by given +refs+ which will be as a queue.
    #
    # @param [Integer, Range, Hash{String => Regexp}, TADA::Ref] *refs
    #   given array will be flatten.
    def initialize(*refs)
      # flatten the refs
      refs.flatten!

      # check each ref has a valid type
      refs.each_with_index do |ref, i|
        if not [Integer, Range, Hash, Ref].include? ref.class
          raise TypeError, \
            "each ref must be Integer, Range, Hash, or Ref"
        end

        # if hash, then make sure keys are string and values are regex
        if ref.is_a?(Hash)
          ref.each_pair do |k, v|
            if not (k.is_a?(String) and v.is_a?(Regexp))
              raise TypeError, "hash ref must be String:Regexp"
            end
          end
        end

        # if ref is a Ref, convert it to array
        refs[i] = ref.to_a if ref.is_a?(Ref)
      end

      # flatten the refs and save
      @refs = refs.flatten
    end

    # Check if it's not nested and there's no rest.
    #
    # @return [true, false]
    def is_singular()
      @refs.size == 1 and @refs[0].class != Ref
    end

    # Convert to array.
    #
    # @return [Array[Integer, Range, Hash]]
    def to_a()
      @refs
    end

    # Get top level singular reference unit.
    #
    # @return [Integer, Range, Hash]
    def head()
      @refs.first
    end

    # Get the rest (nest) of reference units as an array.
    #
    # @return [Array[Integer, Range, Hash]]
    def rest()
      @refs.drop(1)
    end
  end
end
