require "../src/talgene"

struct Item
  getter value : Float64
  getter weight : Float64
  getter volume : Float64

  property? inside : Bool

  def initialize(@value : Float64, @weight : Float64, @volume : Float64, @inside : Bool = false)
  end
end

ITEM_POOL = [
  Item.new(weight: 1.0, value: 2.0, volume: 2.0),
  Item.new(weight: 1.0, value: 4.0, volume: 3.0),
  Item.new(weight: 1.0, value: 2.5, volume: 1.0),
  Item.new(weight: 1.0, value: 3.0, volume: 5.0),
  Item.new(weight: 2.0, value: 1.5, volume: 2.0),
  Item.new(weight: 2.0, value: 0.5, volume: 2.0),
  Item.new(weight: 3.0, value: 4.5, volume: 4.0),
  Item.new(weight: 2.0, value: 8.5, volume: 8.0),
  Item.new(weight: 6.0, value: 5.0, volume: 6.0),
  Item.new(weight: 7.0, value: 5.0, volume: 7.0),
]

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

  getter weight : Float64 do
    sum do |item|
      item.inside? ? item.weight : 0.0
    end
  end

  getter volume : Float64 do
    sum do |item|
      item.inside? ? item.volume : 0.0
    end
  end

  def cross(other : Knapsack) : Knapsack
    new_genes = Talgene::Crossable.single_point_cross(@genes, other.genes).sample

    Knapsack.new new_genes, @max_weight, @max_volume, @mutation_rate
  end

  def mutate : Knapsack
    new_genes = map do |item|
      item.dup.tap do |it|
        if @mutation_rate > rand
          it.inside = !it.inside?
        end
      end
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
  getter selection : Array(Knapsack) do
    other_bucket = @population.reject do |knapsack|
      knapsack.same? fittest
    end

    Array.new @population.size do
      fittest.cross(other_bucket.sample).mutate
    end
  end
end

population_zero = Array.new 50 do
  genes = ITEM_POOL.map do |item|
    unless 0.5 < rand
      Item.new item.value, item.weight, item.volume, true
    else
      item
    end
  end

  Knapsack.new genes, max_weight: 20, max_volume: 25, mutation_rate: 0.3
end

generation_zero = Generation.new population_zero

sys = Talgene::System.new generation_zero, max_iterations: 700 do |current|
  current.best_fitness > 26
end

fittest_ever = sys.max_of &.fittest

puts "System evaluated at generation #{sys.current_iteration}"
puts "Fitness: #{fittest_ever.fitness}"
puts "Weight: #{fittest_ever.weight}"
puts "Volume: #{fittest_ever.volume}"
