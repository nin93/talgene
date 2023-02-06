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
