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
  # The `Talgene::Advanceable` module allows types to have a _successive_.
  #
  # Including types must provide a `#advance` method which returns the next term in the
  # series.
  #
  # ```
  # require "talgene"
  #
  # record Integer, value : Int32 do
  #   include Talgene::Advanceable(Integer)
  #
  #   def advance : Integer
  #     Integer.new @value + 1
  #   end
  # end
  #
  # integer = Integer.new(0)
  # integer.advance # => Integer(@value=1)
  # ```
  module Advanceable(T)
    # Must return the next term of this series.
    abstract def advance : T

    # Returns the term of this series which is `count` steps away or `self` if `count` is
    # negative or zero.
    #
    # ```
    # require "talgene"
    #
    # record Integer, value : Int32 do
    #   include Talgene::Advanceable(Integer)
    #
    #   def advance : Integer
    #     Integer.new @value + 1
    #   end
    # end
    #
    # integer = Integer.new(0)
    # integer.advance(10) # => Integer(@value=10)
    # ```
    def advance(count : Int)
      count.times.reduce self, &.advance
    end
  end
end
