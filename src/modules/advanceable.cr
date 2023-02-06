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
  # class Integer
  #   include Talgene::Advanceable(Integer)
  #
  #   getter value : Int32
  #
  #   def initialize(@value : Int32)
  #   end
  #
  #   def advance : Integer
  #     Integer.new @value + 1
  #   end
  # end
  #
  # integer = Integer.new(0)
  # integer.advance.value # => #<Integer @value=1>
  # ```
  module Advanceable(T)
    # Must return the next term of this series.
    abstract def advance : T

    # Returns a new instance advancing by a fixed number of steps. Negative or zero values
    # for `count` will make this method return a copy of `self`.
    def advance(count : Int)
      count.times.reduce self.dup, &.advance
    end

    # An iterator over types that define an `#advance` method. See `Talgene::Advanceable`
    # module.
    #
    # ```
    # require "talgene"
    #
    # class Integer
    #   include Talgene::Advanceable(Integer)
    #
    #   getter value : Int32
    #
    #   def initialize(@value : Int32)
    #   end
    #
    #   def advance : Integer
    #     Integer.new @value + 1
    #   end
    # end
    #
    # iterator = Talgene::Advanceable::AdvanceIterator.new Integer.new(0)
    # iterator.next # => #<Integer @value=1>
    #
    # # Use `include_first` to include the initial entry
    # iterator = Talgene::Advanceable::AdvanceIterator.new Integer.new(0), include_first: true
    # iterator.next # => #<Integer @value=0>
    # ```
    class AdvanceIterator(T)
      include Iterator(T)

      @early_stop_proc : Proc(T, T?, Int32, Bool)? = nil

      # Creates a new `Talgene::Advanceable::AdvanceIterator` instance from an initial
      # value and a maximum number of advances.
      #
      # When `max_advances` is `nil` the iterator never stops. When `include_first` is
      # `true` the initial entry is used as first value of the iteration. This will not
      # affect the number of total advances.
      def initialize(initial @current : T, *, @max_advances : Int32? = nil, @include_first : Bool = false)
      end

      # Returns the number of advances made in the iteration.
      getter advances : Int32 = 0

      # Returns the previous element of the iteration or `nil` if currently on the first
      # iteration.
      getter previous : T? = nil

      # Returns the current element of the iteration.
      getter current : T

      # Defines an early stop condition that will be checked at every iteration step
      # until `max_advances` is reached. On condition matched the iterator stops
      # immediately.
      #
      # It yields the current element, the previous one and the total number of advances
      # made.
      #
      # ```
      # require "talgene"
      #
      # class Integer
      #   include Talgene::Advanceable(Integer)
      #
      #   getter value : Int32
      #
      #   def initialize(@value : Int32)
      #   end
      #
      #   def advance : Integer
      #     Integer.new @value + 1
      #   end
      # end
      #
      # iterator = Talgene::Advanceable::AdvanceIterator.new Integer.new(0)
      #
      # iterator.stop_on do |int|
      #   int.value > 93.0
      # end
      #
      # # Consume the iterator.
      # iterator.to_a
      # iterator.advances # => 94
      # ```
      def stop_on(&block : T, T?, Int32 -> Bool) : Nil
        @early_stop_proc = block
      end

      def next
        if @include_first
          # Initial value is not needed anymore
          @include_first = false

          @current
        elsif @early_stop_proc.try &.call(@current, @previous, @advances) ||
              # When `@max_advances` is `nil` the iterator never stops.
              @advances == @max_advances
          stop
        else
          @advances += 1

          @previous = @current
          @current = @current.advance
        end
      end
    end
  end
end
