require "../modules/selectable"

module Talgene
  # A convenience abstract class to avoid some boilerplate over the implementation of a
  # `#selection` method.
  abstract class Generation(T)
    include Talgene::Selectable(T)

    # Creates a new `Talgene::Generation` instance with supplied array of individuals.
    def initialize(@population : Array(T))
    end

    # Returns the population of this generation.
    getter population : Array(T)

    # Returns the population individual that scored the best fitness. Once this is
    # computed, the value is cached for future calls.
    #
    # Expects `T` implements `#fitness`. See `Talgene::Fittable`.
    getter fittest : T do
      @population.max_by &.fitness
    end

    # Returns a new `Talgene::Generation` populated by the selection of this generation.
    #
    # See `#selection`.
    def advance
      (typeof(self)).new selection
    end

    # Returns a new `Talgene::Generation` advancing by a fixed number of steps. Negative
    # or zero values for `count` will make this method return a copy of `self`.
    def advance(count : Int)
      count.times.reduce self.dup, &.advance
    end

    # Convenience method to fetch the best fitness yielded from the population. Same as
    # `fittest.fitness`
    def best_fitness
      fittest.fitness
    end

    # Expects `T` implements a `#selection` method. See `Talgene::Selectable` module.
    class GenerationIterator(T)
      include Iterator(T)

      @early_stop_proc : Proc(T, T?, Int32, Bool)? = nil
      @at_start : Bool = true

      # Creates a new `Talgene::Generation::GenerationIterator` instance from an initial
      # value and a maximum number of iterations.
      def initialize(@current : T, @max_iterations : Int32)
      end

      # Creates a new `Talgene::Generation::GenerationIterator` instance with the ability
      # to pass a block to register an early stop condition.
      #
      # See `#stop_on`.
      def initialize(@current : T, @max_iterations : Int32, &block : T, T?, Int32 -> Bool)
        @early_stop_proc = block
      end

      # Returns the number of elapsed elements in the iteration.
      getter elapsed : Int32 = 0

      # Returns the previous element of the iteration or `nil` if currently on the first
      # iteration.
      getter previous : T? = nil

      # Returns the current element of the iteration.
      getter current : T

      # Defines an early stop condition that will be checked at every iteration step
      # until `max_iterations` is reached. On condition matched the iterator stops
      # immediately.
      #
      # It yields the current element, the previous one and the total number of iterated
      # elements.
      #
      # ```
      # require "talgene"
      #
      # class Generation < Talgene::Generation(Float64)
      #   def selection : Array(Float64)
      #     population.map { |x| x + 1 }
      #   end
      # end
      #
      # generation = Generation.new Array.new 5 { rand 100.0 }
      # iterator = Talgene::Generation::GenerationIterator.new generation, 100
      #
      # iterator.stop_on do |current|
      #   current.selection.any? { |e| e > 93.0 }
      # end
      #
      # # Consume the iteration.
      # iterator.to_a
      # iterator.elapsed # => 13
      # ```
      def stop_on(&block : T, T?, Int32 -> Bool) : Nil
        @early_stop_proc = block
      end

      def next
        if @at_start
          @at_start = false

          @current
        elsif @early_stop_proc.try &.call(@current, @previous, @elapsed) ||
              @elapsed == @max_iterations
          stop
        else
          @elapsed += 1

          @previous = @current
          @current = T.new @current.selection
        end
      end
    end
  end
end
