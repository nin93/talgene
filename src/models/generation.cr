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

      getter elapsed : Int32 = 0
      getter current : T

      def initialize(@current : T, @max_iterations : Int32)
      end

      def next
        if @elapsed < @max_iterations
          @elapsed += 1

          @current = T.new @current.selection
        else
          stop
        end
      end
    end
  end
end
