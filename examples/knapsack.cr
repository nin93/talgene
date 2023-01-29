require "../src/talgene"

struct Item
  getter value : Float64
  getter weight : Float64
  getter volume : Float64

  def initialize(@value : Float64, @weight : Float64, @volume : Float64)
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
    @genes : Array(Item), *,
    @max_weight : Float64,
    @max_volume : Float64,
    @mutation_rate : Float64 = 0.1
  )
  end

  @fitness : Float64? = nil

  def cross(other : Knapsack) : Knapsack
    pivot = rand @genes.size

    new_genes = if 0.5 < rand
                  @genes[0...pivot].concat other.genes[pivot..-1]
                else
                  other.genes[0...pivot].concat @genes[pivot..-1]
                end

    Knapsack.new(
      new_genes,
      max_weight: @max_weight,
      max_volume: @max_volume,
      mutation_rate: @mutation_rate
    )
  end

  def mutate : Knapsack
    new_genes = @genes.map_with_index do |gene, i|
      if @mutation_rate < rand
        # remove or insert item into the knapsack
        unless gene.value == 0
          Item.new value: 0, weight: 0, volume: 0
        else
          ITEM_POOL[i]
        end
      else
        gene
      end
    end

    Knapsack.new(
      new_genes,
      max_weight: @max_weight,
      max_volume: @max_volume,
      mutation_rate: @mutation_rate
    )
  end

  def fitness : Float64
    @fitness ||= compute_fitness
  end

  def compute_fitness
    weight = 0.0
    volume = 0.0

    @genes.reduce 0.0 do |value, item|
      unless (weight += item.weight) > @max_weight ||
             (volume += item.volume) > @max_volume
        value + item.value
      else
        0.0
      end
    end
  end
end

class Generation < Talgene::Generation(Knapsack)
  @selection : Array(Knapsack)? = nil

  def selection : Array(Knapsack)
    @selection ||= compute_selection
  end

  private def compute_selection
    other_bucket = @population.reject do |knapsack|
      knapsack.same? fittest
    end

    Array.new @population.size do
      fittest.cross(other_bucket.sample).mutate
    end
  end
end

population = Array.new 500 do
  genes = ITEM_POOL.map do |item|
    unless 0.5 < rand
      Item.new value: 0, weight: 0, volume: 0
    else
      item
    end
  end

  Knapsack.new(
    genes,
    max_weight: 20,
    max_volume: 25,
    mutation_rate: 0.1
  )
end

system = Talgene::System.new(
  generation: Generation.new(population),
  max_iterations: 700
)

fittest_ever = system.each.max_by { |gen| gen.best_fitness }.fittest

puts "Fitness: #{fittest_ever.fitness}"
puts "Weight: #{fittest_ever.genes.sum 0, &.weight}"
puts "Volume: #{fittest_ever.genes.sum 0, &.volume}"
