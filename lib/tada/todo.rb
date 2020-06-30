require 'tada/ref'
require 'tada/status'

module TADA
  class TODO
    attr_accessor :status, :title, :info, :sublist

    def initialize(status, title, info: {}, sublist: [])
      error = proc { |s| raise TypeError, "expected " + s }

      status = Status.new(status)

      error.("status as a TADA::Status") if not status.is_a?(Status)
      error.("title as a String") if not title.is_a?(String)
      error.("info as a Hash") if not info.is_a?(Hash)
      error.("sublist as an Array") if not sublist.is_a?(Array)

      @status = status
      @title = title.strip
      @info = info
      @sublist = sublist
    end

    def create(ref, todo)
      # if ref ends here, make the entry in sublist
      if ref.empty?
        @sublist << todo
        return self
      end

      # select top level refrenced entries
      first = ref.first
      @sublist.each_with_index do |entry, i|
        if entry.match?(first, i)
          @sublist[i] = entry.create(ref.rest, todo)
        end
      end

      return self
    end

    def retrieve(ref)
      return self if ref.empty?

      # select rest of ref on those entries in sublist
      # which match the first of ref
      first = ref.first
      @sublist.each_with_index.select do |entry, i|
        entry.match?(first, i)
      end.map { |x, i| x }
    end

    def update(ref, todo)
      # delete & create entry at ref
      delete(ref)
      create(ref, todo) # returns self
    end

    def delete(ref)
      # if ref ends here, return nil
      nil if ref.empty?

      # select top level refrenced entries
      first = ref.first
      @sublist.each_with_index do |entry, i|
        if entry.match?(first, i)
          @sublist[i] = entry.delete(ref.rest)
        end
      end

      return self
    end

    def move(src_ref, dst_ref)
      # retrieve src as a copy, remove src, create the copy at dest
      todo = retrieve(src_ref)
      delete(src_ref)
      create(dst_ref, todo)

      return self
    end

    def match?(ref, index)
      return ref == index if ref.is_a? Integer
      return ref === index if ref.is_a? Range
      return match?(ref.first) if ref.is_a? Ref

      if ref.is_a? Hash
        ref.each_pair do |key, value|
          return false if not @info.key? key
          return false if @info[key] !~ value
        end

        return true
      end

      raise TypeError, "expected Integer, Range, Ref, or Hash"
    end

    def at(*refs)
      refs.map { |ref| ref.mapretrieve(ref) }
    end

    def set(ref, todo)
      update(ref, todo)
    end

    def [](ref)
      retrieve(ref)
    end

    def []=(ref, todo)
      update(ref, todo)
    end
  end
end
