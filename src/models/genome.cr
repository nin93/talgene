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
  end
end
