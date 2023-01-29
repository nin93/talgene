require "./generation"

module Talgene
  class System(T)
    include Iterable(T)

    getter current_iteration : Int32 = 0
    getter iterator : Talgene::Generation::GenerationIterator(T)

    def initialize(@generation : T, *, @max_iterations : Int32)
      @iterator = Talgene::Generation::GenerationIterator.new @generation, @max_iterations
    end

    def each
      @iterator
    end
  end
end
