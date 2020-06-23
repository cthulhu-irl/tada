module TADA
  class Manager
    include Enumerable

    class << self
      def read(file)
      end

      def write(file, todo_list)
      end

      def load(str)
      end

      def dump(todo_list)
      end
    end

    def initialize(io, parser: TADA::Parsers::JSONParser)
    end

    def open(filepath)
    end

    def close()
    end

    def read(file)
    end

    def write(file)
    end

    def load(str)
    end

    def dump()
    end

    def each()
    end

    #-- Wrappers --

    def create(ref, todo)
      @todo_list = @todo_list.create(ref, todo)
    end

    def retrieve(ref)
      @todo_list = @todo_list.retrieve(ref)
    end

    def update(ref, todo)
      @todo_list = @todo_list.update(ref, todo)
    end

    def delete(ref)
      @todo_list = @todo_list.delete(ref)
    end

    def move(src_ref, dst_ref)
      @todo_list = @todo_list.move(src_ref, dst_ref)
    end

  end
end
