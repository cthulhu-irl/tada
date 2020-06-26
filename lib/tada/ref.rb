module TADA
  class Ref
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
