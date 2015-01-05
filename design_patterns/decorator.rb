# DECORATOR (object structural pattern)
# ============================================

# GoF definition (p. 175):
# -----------------------
# "Attach additional responsibilities to an object dynamically. Decorators
# provide a flexible alternative to subclassing for extending functionality."

# OneDecorator
# [component] ---------> TwoDecorator
#                        [component] ---------> Component

# Very similar to the Strategy Pattern, as you can alter the behavior of a
# component by swapping out decorators or strategies. The key difference is
# that a component maintains a reference to a strategy ('the guts'), while a
# decorator maintains a reference to a component ('the skin').

# NB: Since components and decorators share the same interface, they are
# interchangeable!

# Pros:
# -----
#  * A decorator's interface must conform to the interface of the component
#    it decorates.
#  * Features can be added incrementally to simple components.

# Cons:
# -----
#  * Lots of little objects – behaviors are fragmented among different
#    decorators, which can be difficult to follow.

# Component [superclass to component subclasses and decorators]:
# -------------------------------------------------------------

class Numbers
  attr_accessor :component

  def series(n)
    raise NotImplementedError
  end

  def root_component
    @component ? @component.component : self
  end
end

# Concrete Component:
# -------------------

class Integers < Numbers
  def series(n)
    (1..n).to_a
  end
end

# Decorators:
# ----------

class Doubler < Numbers
  def initialize(component)
    @component = component # a reference to the component it decorates
  end

  # forwards the request to its components with some modification
  def series(n)
    @component.series(n).map { |n| n * 2 }
  end
end

class Inverse < Numbers
  def initialize(component)
    @component = component
  end

  def series(n)
    @component.series(n).map { |n| n * -1 }
  end
end

# -----

integers = Integers.new
p integers.series(5) # => [1, 2, 3, 4, 5]
doubler = Doubler.new(integers)
p doubler.series(5) # => [2, 4, 6, 8, 10]
inverter = Inverse.new(doubler)
p inverter.series(5) # => [-2, -4, -6, -8, -10]
p inverter.root_component # => <Integers>
