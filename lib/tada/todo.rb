# frozen_string_literal: true

require 'tada/ref'
require 'tada/status'

module TADA
  # to do task with nesting and info options, providing CRUD utils.
  class TODO
    attr_accessor :status  # @return [TADA::Status]
    attr_accessor :title   # @return [String]
    attr_accessor :info    # @return [Hash{String => String}]
    attr_accessor :sublist # @return [Array<TADA::TODO>]

    # Make a new TODO object
    #
    # @param [TADA::Status] status
    #   The current status of this task.
    #   +status+ can also be whatever +TADA::Status.new+ accepts
    #   as its first parameter.
    # @param [String] title
    #   Title or summary description of the task.
    # @param [Hash{String => String}] info
    #   Informations about current task.
    # @param [Array<TADA::TODO>] sublist
    #   A list of child tasks for current task.
    def initialize(status, title, info: {}, sublist: [])
      error = proc { |s| raise TypeError, "expected #{s}" }

      status = Status.new(status)

      error.call('status as a TADA::Status') unless status.is_a?(Status)
      error.call('title as a String') unless title.is_a?(String)
      error.call('info as a Hash') unless info.is_a?(Hash)
      error.call('sublist as an Array') unless sublist.is_a?(Array)

      info.each_pair do |k, v|
        error.call('info keys as String') unless k.is_a?(String)
        error.call('info values as String') unless v.is_a?(String)
      end

      sublist.each do |v|
        error.call('sublist cells as TADA::TODO') unless v.is_a?(TODO)
      end

      @status = status
      @title = title.strip
      @info = info
      @sublist = sublist
    end

    # Create the given todo at given refrence.
    #
    # @param [TADA::Ref] ref
    # @param [TADA::TODO] todo
    # @return [TADA::TODO] returns itself
    def create(ref, todo)
      # if ref ends here, make the entry in sublist
      (@sublist << todo) && (return self) if ref.empty?

      # type fix
      ref = Ref.new(ref) unless ref.is_a?(Ref)

      # select top level refrenced entries
      first = ref.first
      @sublist.each_with_index do |entry, i|
        entry.match?(first, i) &&
          @sublist[i] = entry.create(ref.rest, todo)
      end

      self
    end

    # Get/Retrieve a todo entry at given reference.
    #
    # @param [TADA::Ref] ref
    # @return [TADA::TODO, nil] returns nil if not found.
    def retrieve(ref)
      return self if ref.empty?

      # type fix
      ref = Ref.new(ref) unless ref.is_a?(Ref)

      # select rest of ref on those entries in sublist
      # which match the first of ref
      ret = []
      rest = ref.rest
      @sublist.each_with_index.select do |entry, i|
        ret << entry.retrieve(rest) if entry.match?(ref.first, i)
      end

      ret.flatten.compact
    end

    # Update a todo entry at given refrence.
    #
    # @param [TADA::Ref] ref
    # @param [TADA::TODO] todo
    # @return [TADA::TODO] returns given +todo+
    def update(ref, todo)
      # delete & create entry at ref
      delete(ref)
      create(ref, todo) # returns self
    end

    # Remove an entry at given reference.
    #
    # @param [TADA::Ref] ref
    # @return [TADA::TODO, nil]
    #   returns a copy of deleted todo entry or nil if not found.
    def delete(ref)
      # if ref ends here, return nil
      nil if ref.empty?

      # type fix
      ref = Ref.new(ref) unless ref.is_a?(Ref)

      # select top level refrenced entries
      first = ref.first
      @sublist.each_with_index do |entry, i|
        @sublist[i] = entry.delete(ref.rest) if entry.match?(first, i)
      end

      self
    end

    # Moves a todo entry at +src_ref+ to +dst_ref+
    # by +#retrieve+, +#delete+ and +#create+.
    #
    # @param [TADA::Ref] src_ref
    # @param [TADA::Ref] dst_ref
    # @return [TADA::TODO] returns itself
    def move(src_ref, dst_ref)
      # retrieve src as a copy, remove src, create the copy at dest
      todo = retrieve(src_ref)
      delete(src_ref)
      create(dst_ref, todo)

      self
    end

    # checks if this entry match given reference considering that
    # this entry is at given index of its parent's sublist.
    #
    # @param [TADA::Ref, Integer, Range, Hash] ref
    # @param [Integer] index
    # @return [true, false]
    # @raise TypeError
    def match?(ref, index = 0)
      return ref == index if ref.is_a? Integer
      return ref.include? index if ref.is_a? Range

      return title.include?(ref) if ref.is_a? String
      return ref.match?(title) if ref.is_a? Regexp

      return status == ref if ref.is_a? Status
      return status == Status.new(ref) if ref.is_a? Symbol

      return match?(ref.first) if ref.is_a? Ref

      if ref.is_a? Hash
        ref.each_pair do |key, value|
          return false if !@info.key?(key) || @info[key] !~ value
        end

        return true
      end

      raise TypeError, 'expected Integer, Range, Ref, or Hash'
    end

    # Retrieve all given references.
    #
    # @param [TADA::Ref] refs
    # @return [Array<TADA::TODO, nil>]
    def at(*refs)
      refs.map { |ref| retrieve(ref) }
    end

    # Create/Update an entry at given reference.
    #
    # @param [TADA::Ref] ref
    # @param [TADA::TODO] todo
    def set(ref, todo)
      update(ref, todo)
    end

    # Retrieve given reference.
    #
    # @param [TADA::Ref] ref
    # @return [TADA::TODO, nil]
    def [](ref)
      retrieve(ref)
    end

    # same as {#set}
    #
    # @param [TADA::Ref] ref
    # @param [TADA::TODO] todo
    def []=(ref, todo)
      update(ref, todo)
    end
  end
end
