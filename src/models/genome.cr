require "../modules/fittable"

module Talgene
  # A convenience abstract class to avoid some boilerplate over the implementation of a
  # `#fitness` method.
  #
  # ```
  # require "talgene"
  #
  # class Model < Talgene::Genome(Int32)
  #   def fitness : Float64
  #     genes.each.slice(2).sum 0.0 do |(x, y)|
  #       y - x
  #     end
  #   end
  # end
  #
  # model = Model.new [0, 1, 2, 3, 4, 5]
  # model.fitness # => 3.0
  # ```
  abstract class Genome(T)
    include Talgene::Fittable
    include Indexable(T)

    # Creates a new `Talgene::Genome` instance with supplied array of genes.
    def initialize(@genes : Array(T))
    end

    # Returns the underlying array of genes of this genetic representation.
    getter genes : Array(T)

    @[AlwaysInline]
    def unsafe_fetch(index : Int)
      @genes.unsafe_fetch index
    end

    def size
      @genes.size
    end

    def to_s(io : IO)
      @genes.each_with_index do |gene, i|
        io << gene.to_s
      end
    end
  end
end
