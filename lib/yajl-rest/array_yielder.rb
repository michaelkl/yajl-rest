# frozen_string_literal: true

module YajlRest
  # Parse JSON array and pass items to the Enumerator::Yielder
  class ArrayYielder
    METHODS = %w[start_document end_document start_object end_object start_array end_array key value]

    #attr_reader :result

    # @param parser [Yajl::FFI::Parser]
    # @param yielder [Enumerator::Yielder]
    def initialize(parser, yielder)
      @yielder = yielder
      METHODS.each do |name|
        parser.send(name, &method(name))
      end
    end

    def start_document
      @stack = []
      @keys = []
      #@result = nil
    end

    def end_document
      raise Yajl::FFI::ParserError unless @stack.size == 1
      #@result = @stack.pop
    end

    def start_object
      unless @stack.first.is_a? Array
        raise Yajl::FFI::ParserError, 'document is not a JSON array'
      end
      @stack.push({})
    end

    def end_object
      return if @stack.size == 1
      if @stack.size == 2
        @yielder << @stack.pop
        return
      end

      node = @stack.pop
      top = @stack[-1]

      case top
      when Hash
        top[@keys.pop] = node
      when Array
        top << node
      end
    end
    alias :end_array :end_object

    def start_array
      @stack.push([])
    end

    def key(key)
      @keys << key
    end

    def value(value)
      top = @stack[-1]
      case top
      when Hash
        top[@keys.pop] = value
      when Array
        top << value
      else
        @stack << value
      end
    end
  end
end
