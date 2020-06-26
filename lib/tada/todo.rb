module TADA
  class TODO
    attr_accessor :status, :title, :info, :sublist

    def initialize(status, title, info: {}, sublist: [])
      # TODO types and constraints validation
      @status = status
      @title = title.strip
      @info = info
      @sublist = sublist
    end

    def create(ref, todo)
      # if ref ends here, make the entry
        # get first of ref entries
        # call create on each entry and pass given entry to them
        # return self

      # add given entry to sublist
      # return self
    end

    def retrieve(ref)
      # return nil if ref is empty
      # get the first of ref
      # call corresponding selector depending on ref.first's type
      # save the result in a variable
      # if ref has a rest (ref.rest)
        # call retrieve and pass the rest on each entry in result
        # if returned value isn't nil
          # replace the entry with returned value from the result
      # flatten the result (or not!)
      # return the result
    end

    def update(ref, todo)
      # return nil if ref is empty
      # get the first of ref
      # call corresponding selector depending on ref.first's type
      # save the result in a variable
      # if ref has a rest (ref.rest)
        # call retrieve and pass the rest on each entry in result
        # if returned value isn't nil
          # replace the entry with returned value from the result
      # flatten the result
      # update self.sublist
      # return self
    end

    def delete(ref)
      # return nil if ref is empty
      # get the first of ref
      # call corresponding selector depending on ref.first's type
      # save the result in a variable
      # if ref has a rest (ref.rest)
        # call retrieve and pass the rest on each entry in result
        # if returned value isn't nil
          # replace the entry with returned value from the result
      # flatten the result
      # update self.sublist by removing entries
      #   in the result from sublist
      # return self
    end

    def move(src_ref, dst_ref)
      # retrieve src as a copy, remove src, create the copy at dest
      todo = retrieve(src_ref)
      delete(src_ref)
      create(dst_ref, todo)

      return self
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

    def each_in_depth(depth: -1, &block)
      # if depth equals 0, then return self
      # yield self or return Enumerator
      # for each entry in sublist
        # set next_depth to depth
        # unless depth be negtaive
          # set the next_depth to one less what it is
        # call each_in_depth with next_depth and given block
      # return Enumerator or nil
    end
  end
end
