# STRATEGY (object behavioral pattern)
# ====================================

# GoF definition (p. 315): 
# ------------------------
# "Define a family of algorithms, encapsulate each one, and make them
# interchangeable. Strategy lets the algorithm vary independently
# from clients that use it."

# Like the 'template method' pattern, but rather than use subclassing
# to change the target algorithm, we take the algorithm and place it 
# within a separate object ("strategy") that can be composed within 
# another object ("context"). These strategies have the same interface
# and are, from the context's perspective, interchangeable.

# Pros:
# ----
#  * Algorithms are encapsulated within interchangeable 'strategies'.
#  * "Context" is decoupled from the implementation of the algorithm.

# Strategies:
# ----------

class Food
  def grill
    raise NotImplementedError
  end
end

class Burger < Food
  def grill
    puts "The burger sizzles."
  end
end

class Hotdog < Food
  def grill
    puts "The hotdog turns golden brown."
  end
end

# Context:
# -------

class Grill
  attr_accessor :food

  def initialize(food)
    @food = food # food can be any strategy with the '#grill' interface
  end

  def grill_food
    @food.grill
  end
end

# -----

my_grill = Grill.new(Burger.new)
my_grill.grill_food
my_grill.food = Hotdog.new # Strategies are interchangeable
my_grill.grill_food # Same method call, now performed with a different strategy
