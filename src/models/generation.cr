require "../modules/selectable"

module Talgene
  abstract class Generation(T)
    include Talgene::Selectable(T)

    @fittest : T? = nil

    getter population : Array(T)

    def initialize(@population : Array(T))
    end

    def best_fitness
      fittest.fitness
    end

    def fittest : T
      @fittest ||= compute_fittest
    end

    private def compute_fittest
      @population.max_by &.fitness
    end

    class GenerationIterator(T)
      include Iterator(T)

      @at_start : Bool = true

      getter elapsed : Int32 = 0
      getter current : T

      def initialize(@current : T, @max_iterations : Int32)
      end

      def next
        if @at_start
          @at_start = false

          @current
        elsif @elapsed == @max_iterations
          stop
        else
          @elapsed += 1
          @current = T.new @current.selection
        end
      end
    end
  end
end
