# TEMPLATE (class behavioral pattern)
# ===================================

# GoF definition (p. 325):
# -----------------------
# "Define the skeleton of an algorithm in an operation, defeering some steps
# to subclasses. Template methods lets subclasses redefine certain steps of an
# algorithm without changing the algorithm's structure."

# More succinctly, "a template method defines an algorithm in terms of 
# abstract operations that subclasses override to provide concrete behavior"
# (GoF p. 326)

# You should also draw a distinction between these abstract operations (which
# MUST be overriden) and "hook" operations (which MAY be overriden).

# Pros:
# -----
#  * Fundamental technique for code reuse - factor the structure of algorithm 
#    into an abstract superclass.

# Cons:
# -----
#  * Subclass writers must remember which operations need to be overriden. This
#    is its own kind of dependency!

# Abstract class
# --------------

class Animal
  attr_accessor :name

  # Here is our template method:
  def survive
    self.eat
    self.poop
    self.procreate
  end

  def eat
    raise NotImplementedError
  end

  def poop
    raise NotImplementedError
  end

  def procreate
    raise NotImplementedError
  end
end

# Concrete classes
# ----------------

class Monkey < Animal
  def initialize
    @name = "monkey"
  end

  def eat
    puts "The #{@name} eats a banana."
  end

  def poop
    puts "The #{@name} defecates into its hand."
  end

  def procreate
    puts "The #{@name} hoots at a nearby female."
  end
end

class Turtle < Animal
  def initialize
    @name = "turtle"
  end 
  def eat
    puts "The #{@name} lazily chews some lettuce."
  end

  def poop
    puts "The #{@name} relieves itself on the grass."
  end

  def procreate
    puts "The #{@name} stares intently at a female. She is far away."
  end
end

# -----
george = Monkey.new
george.survive
slowpoke = Turtle.new
slowpoke.survive
