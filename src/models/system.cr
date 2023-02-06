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
  class System(T)
    include Iterator(T)
    include IteratorWrapper

    def initialize(@iterator : Talgene::Advanceable::AdvanceIterator(T))
    end

    def self.new(initial : T, **iterator_options)
      iterator = Talgene::Advanceable::AdvanceIterator.new initial, **iterator_options
      System.new iterator
    end

    def self.new(initial : T, **iterator_options)
      iterator = Talgene::Advanceable::AdvanceIterator.new initial, **iterator_options
      system = System.new iterator

      with system yield
      system
    end

    def next
      wrapped_next
    end

    def stop_on(&block : T, T?, Int32 -> Bool)
      @iterator.stop_on &block
    end

    def advances
      @iterator.advances
    end
  end
end
