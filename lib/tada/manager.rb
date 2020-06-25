module TADA
  class Manager
    include Enumerable

    class << self
      def read(file, parser: TADA::Parsers::JSONParser)
        # parser.load(file.read())
      end

      def write(file, todo_list, parser: TADA::Parsers::JSONParser)
        # file.write(parser.dump(todo_list))
      end

      def load(str, parser: TADA::Parsers::JSONParser)
        # same as parser.load(str)
      end

      def dump(todo_list, parser: TADA::Parsers::JSONParser)
        # same as parser.dump(todo_list)
      end
    end

    def initialize(rfile, wfile: nil,
                    parser: TADA::Parsers::JSONParser)
      # parse and assign each argument to its internal variable
      # set @todo_list by reading @rfile
    end

    def load(str)
      # same as @todo_list = Manager.load(str)
    end

    def dump()
      # same as Manager.dump(@todo_list)
    end

    def each(&block)
      # same as @todo_list.each
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
