# MIT License
#
# Copyright (c) 2023 Elia Franzella <eliafranzella@live.it>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
