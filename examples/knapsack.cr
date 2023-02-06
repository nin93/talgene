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

require "../src/talgene"

struct Item
  getter value : Float64
  getter weight : Float64
  getter volume : Float64

  property? inside : Bool

  def initialize(@value : Float64, @weight : Float64, @volume : Float64, @inside : Bool = false)
  end
end

class Knapsack < Talgene::Genome(Item)
  def initialize(
    @genes : Array(Item),
    @max_weight : Float64,
    @max_volume : Float64,
    @mutation_rate : Float64
  )
  end

  getter fitness : Float64 do
    compute_fitness
  end

  def weight
    sum do |item|
      item.inside? ? item.weight : 0.0
    end
  end

  def volume
    sum do |item|
      item.inside? ? item.volume : 0.0
    end
  end

  def cross(other : Knapsack)
    Talgene::Crossable.single_point_cross(@genes, other.genes).map do |new_genes|
      Knapsack.new new_genes, @max_weight, @max_volume, @mutation_rate
    end
  end

  def mutate : Knapsack
    new_genes = map do |item|
      new_item = item.dup

      if @mutation_rate > rand
        new_item.inside = !new_item.inside?
      end

      new_item
    end

    Knapsack.new new_genes, @max_weight, @max_volume, @mutation_rate
  end

  private def compute_fitness
    weight = 0.0
    volume = 0.0

    reduce 0.0 do |fitness, item|
      unless item.inside?
        fitness
      else
        if (weight += item.weight) > @max_weight ||
           (volume += item.volume) > @max_volume
          break 0.0
        else
          fitness + item.value
        end
      end
    end
  end
end

class Generation < Talgene::Generation(Knapsack)
  def advance : Generation
    other_bucket = population.reject do |knapsack|
      knapsack.same? fittest
    end

    new_population = [] of Knapsack

    while new_population.size < population.size
      offsprings = fittest.cross other_bucket.sample

      diff = population.size - new_population.size
      needed = Math.min offsprings.size, diff
      bucket = offsprings.first needed

      new_population.concat bucket.map &.mutate
    end

    Generation.new new_population
  end
end

ITEM_POOL = [
  Item.new(2.0, 1.0, 2.0), Item.new(4.0, 1.0, 3.0), Item.new(2.5, 1.0, 1.0),
  Item.new(3.0, 1.0, 5.0), Item.new(1.5, 2.0, 2.0), Item.new(0.5, 2.0, 2.0),
  Item.new(4.5, 3.0, 4.0), Item.new(8.5, 2.0, 8.0), Item.new(5.0, 6.0, 6.0),
  Item.new(5.0, 7.0, 7.0),
]

population_zero = Array.new 50 do
  Knapsack.new ITEM_POOL.dup, 20, 25, mutation_rate: 0.1
end

generation_zero = Generation.new population_zero

sys = Talgene::System.new generation_zero, max_advances: 100 do
  stop_on do |current|
    current.best_fitness > 26
  end
end

fittest_ever = sys.max_of &.fittest

puts "System evaluated at generation #{sys.advances}"
puts "Fitness: #{fittest_ever.fitness}"
puts "Weight: #{fittest_ever.weight}"
puts "Volume: #{fittest_ever.volume}"
