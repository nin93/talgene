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
  module Crossable
    def self.single_point_cross(parent_1 : Enumerable, parent_2 : Enumerable, random = Random)
      min_size = Math.min parent_1.size, parent_2.size
      pivot = random.rand min_size

      chunk_left_1 = parent_1.first pivot
      chunk_right_1 = parent_1.skip pivot

      chunk_left_2 = parent_2.first pivot
      chunk_right_2 = parent_2.skip pivot

      offspr_1 = chunk_left_1.concat chunk_right_2
      offspr_2 = chunk_left_2.concat chunk_right_1

      {offspr_1, offspr_2}
    end
  end
end
