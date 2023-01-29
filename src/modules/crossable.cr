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
