require "../modules/selectable"

module Talgene
  abstract class Generation(T)
    include Talgene::Selectable(T)

    def initialize(@population : Array(T))
    end

    getter population : Array(T)

    getter fittest : T do
      @population.max
    end

    def best_fitness
      fittest.fitness
    end

    class GenerationIterator(T)
      include Iterator(T)

      @early_stop_proc : Proc(T, T?, Int32, Bool)? = nil
      @at_start : Bool = true

      getter elapsed : Int32 = 0
      getter previous : T? = nil
      getter current : T

      def initialize(@current : T, @max_iterations : Int32)
      end

      def initialize(@current : T, @max_iterations : Int32, &block : T, T?, Int32 -> Bool)
        @early_stop_proc = block
      end

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
