require "../modules/fittable"

module Talgene
  abstract class Genome(T)
    include Talgene::Fittable

    getter genes : Array(T)

    def initialize(@genes : Array(T))
    end

    def to_s(io : IO)
      @genes.each_with_index do |gene, i|
        io << gene.to_s
      end
    end
  end
end
