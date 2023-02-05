require "../modules/advanceable"

module Talgene
  class System(T)
    include Iterable(T)
    include Enumerable(T)

    def initialize(@iterator : Talgene::Advanceable::AdvanceIterator(T))
    end

    def self.new(initial : T, **iterator_options)
      iterator = Talgene::Advanceable::AdvanceIterator.new initial, **iterator_options
      System.new iterator
    end

    def self.new(initial : T, **iterator_options)
      iterator = Talgene::Advanceable::AdvanceIterator.new initial, **iterator_options
      system = System.new iterator

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
