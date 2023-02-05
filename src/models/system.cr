require "../modules/advanceable"

module Talgene
  class System(T)
    include Iterable(T)
    include Enumerable(T)

    @iterator : Talgene::Advanceable::AdvanceIterator(T)

    def initialize(initial : T, *, max_advances : Int32)
      @iterator = Talgene::Advanceable::AdvanceIterator.new initial, max_advances: max_advances
    end

    def self.new(initial : T, *, max_advances : Int32)
      system = System.new initial, max_advances: max_advances
      with system yield
      system
    end

    def stop_on(&block : T, T?, Int32 -> Bool)
      @iterator.stop_on &block
    end

    def current_iteration
      @iterator.advances
    end

    def each
      @iterator
    end

    def each(& : T ->)
      @iterator.each { |gen| yield gen }
    end
  end
end
