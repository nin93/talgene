module Talgene
  module Fittable
    include Comparable(Fittable)

    abstract def fitness : Float64

    def <=>(other : Fittable)
      fitness <=> other.fitness
    end
  end
end
