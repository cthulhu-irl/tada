# frozen_string_literal: true

require 'tada/status'

module TADA
  # nested reference to point at several todos
  class Ref
    VALID_REF_TYPES = [
      Integer, String, Regexp, Status, Symbol, Range, Hash, Ref
    ].freeze

    # Make a reference by given +refs+ which will be as a queue.
    #
    # @param [Array<Integer, Range, Hash{String => Regexp}, TADA::Ref>] refs
    #   given array will be flatten.
    # @raise TypeError
    def initialize(*refs)
      # flatten the refs
      refs.flatten!

      # check each ref has a valid type
      refs.each_with_index do |ref, i|
        unless VALID_REF_TYPES.include? ref.class
          raise \
            TypeError,
            "each ref must be either #{VALID_REF_TYPES.join(', ')}"
        end

        # if hash, then make sure keys are string and values are regex
        if ref.is_a?(Hash)
          ref.each_pair do |k, v|
            raise TypeError, 'hash ref must be String:Regexp' \
              unless k.is_a?(String) && v.is_a?(Regexp)
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
    def singular?
      @refs.size == 1
    end

    # Convert to array.
    #
    # @return [Array[Integer, Range, Hash]]
    def to_a
      @refs
    end

    # Get top level singular reference unit.
    #
    # @return [Integer, Range, Hash]
    def first
      @refs.first
    end

    # Get the rest (nest) of reference units as an array.
    #
    # @return [Array[Integer, Range, Hash]]
    def rest
      @refs.drop(1)
    end

    # Checks if the reference stack is empty.
    #
    # @return [true, false]
    def empty?
      @refs.empty?
    end
  end
end
