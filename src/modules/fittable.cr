module Talgene
  # The `Talgene::Fittable` module allows genetic model instances to be compared by their
  # fitness. Equally good solutions are related by the same fitness value.
  #
  # ```
  # require "talgene"
  #
  # class Model
  #   include Talgene::Fittable
  #
  #   getter fitness : Float64 do
  #     rand(10).to_f
  #   end
  # end
  #
  # models = Array.new 5 { Model.new }.sort
  # values = models.map &.fitness
  # values # => [1.0, 3.0, 5.0, 5.0, 9.0]
  # ```
  #
  # Including types must provide a `#fitness` method which returns the solution domain.
  module Fittable
    include Comparable(Fittable)

    # Returns the solution domain.
    abstract def fitness : Float64

    def <=>(other : Fittable)
      fitness <=> other.fitness
    end
  end
end
