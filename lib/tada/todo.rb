module TADA
  class TODO
    include Enumerable

    attr_accessor :status, :title, :info, :sublist

    def initialize(status, title, info: {}, sublist: [])
      @status = status
      @title = title.strip
      @info = info
      @sublist = sublist
    end

    def create(ref, todo)
    end

    def retrieve(ref)
    end

    def update(ref, todo)
    end

    def delete(ref)
    end

    def move(src_ref, dst_ref)
    end

    def at(*refs)
    end

    def set(ref, todo)
    end

    def [](ref)
    end

    def []=(ref, todo)
    end

    def each()
    end
  end
end
