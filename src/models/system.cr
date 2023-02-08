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
  # `Talgene::System` is an iterator over types that define an `#advance` method.
  # See `Talgene::Advanceable` module.
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
  # system = Talgene::System.new Integer.new(0)
  # system.next # => Integer(@value=1)
  #
  # # Use `include_first` to include the initial entry
  # system = Talgene::System.new Integer.new(0), include_first: true
  # system.next # => Integer(@value=0)
  # ```
  class System(T)
    include Iterator(T)

    @early_stop_proc : Proc(T, T?, Int32, Bool)? = nil

    # Creates a new `Talgene::System` instance from an initial value and given options.
    #
    # When `max_advances` is `nil` the iterator never stops.
    # When `include_first` is `true` the initial entry is used as first value of the
    # iteration. This will not affect the number of total advances.
    def initialize(
      initial @current : T, *,
      @max_advances : Int32? = nil,
      include_first @at_start : Bool = false
    )
    end

    # Creates a new `Talgene::System` instance and yields with that newly created instance
    # as the default receiver for method calls within the block.
    def self.new(initial : T, **options)
      system = System.new initial, **options
      with system yield
      system
    end

    # Returns the number of advances made in the iteration.
    getter advances : Int32 = 0

    # Returns the previous element of the iteration or `nil` if currently on the first
    # iteration.
    getter previous : T? = nil

    # Returns the current element of the iteration.
    getter current : T

    def next
      if @at_start
        # Initial value is not needed anymore
        @at_start = false

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

    # Defines an early stop condition that will be checked at every iteration step until
    # `max_advances` is reached. On condition matched the iterator stops immediately.
    #
    # It yields the current element, the previous one and the total number of advances
    # made.
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
    # system = Talgene::System.new Integer.new(0)
    #
    # system.stop_on do |int|
    #   int.value > 93.0
    # end
    #
    # system.size # => 94
    # ```
    def stop_on(&block : T, T?, Int32 -> Bool) : Nil
      @early_stop_proc = block
    end
  end
end
