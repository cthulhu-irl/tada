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
      # if ref is not nil
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
      # retrieve src_ref entry into src
      # delete src_ref entry
      # create src entry at dst_ref
    end

    def at(*refs)
      # same as retireve(Ref(refs))
    end

    def set(ref, todo)
      # same as update(Ref(refs), todo)
    end

    def [](ref)
      # same as retrieve(ref)
    end

    def []=(ref, todo)
      # same as update(ref, todo)
    end

    def each_in_depth(depth: -1, &block)
    end
  end
end
