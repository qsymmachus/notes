# STATE (object behavioral pattern)
# =================================

# GoF definition (p. 305):
# -----------------------
# "Allow an object to alter its behavior when its internal state changes. The
# object will appear to change its class."

# The crux of this pattern is to encapsulate the state and state-related
# behaviors of an object within another object. This mitigates the need
# for complicated control-flow based on state, and delegates state-specific
# behaviors to the state object. Very similar to the Strategy pattern in
# this respect.

# Either the parent object or the state object can determine which state
# succeeds another.

# Pros:
# -----
#  * Encapsulates state and state-specific behavior within an internal and
#    interchangeable object.
#  * Eliminates the need for complicated control-flow based on state.
#  * Prevents inconsistent or contradictory states by delegating state to
#    a single object instance (thereby making state 'atomic').

# Context [parent object, maintains an instance of state object]
# --------------------------------------------------------------

class Car
  attr_accessor :state

  def initialize
    @state = Neutral.new
  end

  def throttle
    @state.throttle
  end

  def brake
    @state.brake
  end

  # We also delegate state transitions to the state object:

  def shift_up
    @state.shift_up(self) 
  end

  def shift_down
    @state.shift_down(self)
  end
end

# State [contains the context's state and state-related behaviors]
# ----------------------------------------------------------------

class CarState
  def throttle
    raise NotImplementedError
  end

  def brake
    raise NotImplementedError
  end

  def shift_up(car)
    raise NotImplementedError
  end

  def shift_down(car)
    raise NotImplementedError
  end
end

class Neutral < CarState
  def throttle
    puts "The engine revs loudly but you remain motionless."
  end

  def brake
    puts "Your brake lights flash on. Nothing else happens."
  end

  def shift_up(car)
    puts "You shift into drive."
    car.state = Drive.new
  end

  def shift_down(car)
    puts "You are already in neutral."
    car.state = self
  end
end

class Drive < CarState
  def throttle
    puts "The engine revs and you begin to move forward."
  end

  def brake
    puts "You begin to slow down."
  end

  def shift_up(car)
    puts "You are already in drive."
    car.state = self
  end

  def shift_down(car)
    puts "You shift into neutral."
    car.state = Neutral.new
  end
end

# -----

my_saab = Car.new
my_saab.throttle
my_saab.shift_up
my_saab.throttle
my_saab.brake
my_saab.shift_down
