require "../modules/advanceable"

module Talgene
  # A convenience abstract class to avoid some boilerplate over the implementation of a
  # `#advance` method.
  abstract class Generation(T)
    include Talgene::Advanceable(Generation(T))

    # Creates a new `Talgene::Generation` instance with supplied array of individuals.
    def initialize(@population : Array(T))
    end

    # Returns the population of this generation.
    getter population : Array(T)

    # Returns the population individual that scored the best fitness. Once this is
    # computed, the value is cached for future calls.
    #
    # Expects `T` implements `#fitness`. See `Talgene::Fittable`.
    getter fittest : T do
      @population.max_by &.fitness
    end

    # Convenience method to fetch the best fitness yielded from the population. Same as
    # `fittest.fitness`
    def best_fitness
      fittest.fitness
    end
  end
end
