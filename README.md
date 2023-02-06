# Talgene

A simple programming abstraction layer over
[genetic algorithms](https://en.wikipedia.org/wiki/Genetic_algorithm) implementations.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     talgene:
       github: nin93/talgene
   ```

2. Run `shards install`

## Usage

```crystal
require "talgene"
```

### Genome

Start by defining your genetic representation for your model. In the following example we
implement a solution for the [knapsack problem](https://en.wikipedia.org/wiki/Knapsack_problem).

An abstract class `Talgene::Genome` is provided for this purpose, requiring you to
implement all the methods needed. Within each model a `fitness` function is expected to be
defined to evaluate the solution domain:

```crystal
class Item
  getter value : Float64
  getter weight : Float64

  property? inside : Boolean

  def initialize(@value : Float64, @weight : Float64, @inside : Boolean)
  end
end

class Knapsack < Talgene::Genome(Item)
  def initialize(@genes : Array(Item), @max_weight : Float64)
  end

  def fitness
    weight = 0.0

    reduce 0.0 do |fitness, item|
      unless item.inside?
        fitness
      else
        if (weight += item.weight) > @max_weight
          break 0.0
        else
          fitness + item.value
        end
      end
    end
  end
end
```

One could implement custom, yet classic, rules for genetic recombination such as crossover
and mutation functions. For example, using our `Knapsack` model from above:

```crystal
class Knapsack < Talgene::Genome(Item)
  # Storing a mutation rate as well
  def initialize(@genes : Array(Item), @max_weight : Float64, @mutation_rate : Float64)
  end

  def cross(other : Knapsack) : Knapsack
    new_genes = Talgene::Crossable.single_point_cross(@genes, other.genes).sample

    Knapsack.new new_genes, @max_weight, @mutation_rate
  end

  def mutate : Knapsack
    new_genes = map do |item|
      new_item = item.dup

      if @mutation_rate > rand
        new_item.inside = !new_item.inside?
      end

      new_item
    end

    Knapsack.new new_genes, @max_weight, @mutation_rate
  end
end
```

### Generation

We now need to define the rules to perform a selection among competing individuals within
a population and start a new generation. This is done by inheriting from the
`Talgene::Generation` abstract class and by implementing an `advance` method:

```crystal
class Generation < Talgene::Generation(Knapsack)
  def advance : Generation
    # Avoid recombination with self
    other_bucket = population.reject do |knapsack|
      knapsack.same? fittest
    end

    new_population = Array.new population.size do
      fittest.cross(other_bucket.sample).mutate
    end

    Generation.new new_population
  end
end
```

### System

`Talgene::System` takes care to iterate through generations. We load the generation zero:

```crystal
# Initialize your generation zero
population_zero = [...] of Knapsack
generation_zero = Generation.new population_zero

sys = Talgene::System.new generation_zero, max_advances: 100

# Use `include_first: true` to include the generation zero
sys = Talgene::System.new generation_zero, max_advances: 100, include_first: true
```

Since `Talgene::System` includes the `Enumerable` module, a set of convenient
methods are provided such as `max_by`, `skip_while`, `select`, `each_cons`.

```crystal
# The fittest among all generations is easy to find with `max_of`.
fittest_ever = sys.max_of &.fittest
fittest_ever.fitness # => 26.5
```

Optionally, a `Talgene::System` can be initialized with a rule declaring when an evolution
process should be ended in advance, useful in those cases in which we would expect a good
enough individual beforehand.

For instance:

```crystal
sys = Talgene::System.new generation_zero, max_advances: 100 do
  stop_on do |current|
    current.best_fitness > 26
  end
end

# Consume the iterator
sys.size      # => 4
sys.each.next # => Iterator::Stop
```

A [full example](./examples/knapsack.cr) can be found in the examples folder.

## Contributing

1. Fork it (<https://github.com/nin93/talgene/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Elia Franzella](https://github.com/nin93) - creator and maintainer
