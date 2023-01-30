require "./generation"

module Talgene
  class System(T)
    include Iterable(T)
    include Enumerable(T)

    @iterator : Talgene::Generation::GenerationIterator(T)

    def initialize(initial : T, *, max_iterations : Int32)
      @iterator = Talgene::Generation::GenerationIterator.new initial, max_iterations
    end

    def self.new(initial : T, *, max_iterations : Int32)
      system = System.new initial, max_iterations: max_iterations
      with system yield
      system
    end

    def stop_on(&block : T -> Bool)
      @iterator.stop_on &block
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
