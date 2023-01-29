require "./generation"

module Talgene
  class System(T)
    include Iterable(T)
    include Enumerable(T)

    def initialize(@generation : T, *, @max_iterations : Int32)
      @iterator = Talgene::Generation::GenerationIterator.new @generation, @max_iterations
    @iterator : Talgene::Generation::GenerationIterator(T)

    end

    def initialize(@generation : T, *, @max_iterations : Int32, &block : T -> Bool)
      @iterator = Talgene::Generation::GenerationIterator.new @generation, @max_iterations, &block
    end

    def current_iteration
      @iterator.elapsed
    end

    def each
      @iterator
    end

    def each(& : T ->)
      @iterator.each { |gen| yield gen }
    end
  end
end
