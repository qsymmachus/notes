# ABSTRACT FACTORY (object creational pattern)
# ============================================

# GoF definition (p. 87):
# -----------------------
# "Provide and interface for creating families of related or dependent objects
# without specifying their concrete classes."

# "Factories" encapsulate the creation of an object, and families of objects
# may have families factories with the same interface. This makes it easy to 
# change the type of object built by the client by swapping out the factory.

# Pros:
# -----
#  * The creation of objects is encapsulated within interchangeable factories.

# Objects to be built:
# --------------------

class Vehicle
  attr_accessor :model

  def initialize(model)
    @model = model
  end
end

class Sedan < Vehicle
  def description
    "This is a #{model}, a Sedan."
  end
end

class Van < Vehicle
  def description
    "This is a #{model}, a Van."
  end
end

# Factories: 
# ----------

class AbstractFactory
  def build(model)
    raise NotImplementedError
  end
end

class SedanFactory < AbstractFactory
  def build(model)
    Sedan.new(model)
  end
end

class VanFactory < AbstractFactory
  def build(model)
    Van.new(model)
  end
end

# Client:
# -------

class Dealership
  attr_accessor :factory
  attr_reader :inventory

  def initialize(factory)
    @inventory = []
    @factory = factory
  end

  def order_vehicles(count, model)
    count.times { @inventory << @factory.build(model) }
  end

  def list_inventory
    @inventory.each { |vehicle| puts vehicle.description }
  end
end

# -----

ford_dealership = Dealership.new(SedanFactory.new)
ford_dealership.order_vehicles(3, "Focus")
ford_dealership.list_inventory

ford_dealership.factory = VanFactory.new # Let's switch factories
ford_dealership.order_vehicles(2, "E-350")
ford_dealership.list_inventory
