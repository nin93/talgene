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

      @early_stop_proc : Proc(T, Bool)? = nil
      @at_start : Bool = true

      getter elapsed : Int32 = 0
      getter current : T

      def initialize(@current : T, @max_iterations : Int32)
      end

      def initialize(@current : T, @max_iterations : Int32, &block : T -> Bool)
        @early_stop_proc = block
      end

      def next
        if @at_start
          @at_start = false

          @current
        elsif @early_stop_proc.try &.call(@current) ||
              @elapsed == @max_iterations
          stop
        else
          @elapsed += 1
          @current = T.new @current.selection
        end
      end
    end
  end
end
