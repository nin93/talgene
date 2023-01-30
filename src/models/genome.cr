require "../modules/fittable"

module Talgene
  abstract class Genome(T)
    include Talgene::Fittable
    include Indexable(T)

    getter genes : Array(T)

    def initialize(@genes : Array(T))
    end

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
