# OBSERVER (object behavioral)
# ============================

# GoF definition (p. 293):
# -----------------------
# "Define a one-to-many dependency between objects so that when one object
# changes state, all its dependents are notified and updated automatically."

# Also known as the publish-subscribe pattern.

# Pros:
# -----
#  * Loose coupling between the subject and observer – all a subject knows is
#    its list of observers. The subject doesn't know what its observers do.
#  * Allows for broadcast communication – a subject doesn't care how many
#    subscribers there are, and it doesn't need to target its message.
#  * When combined with the mediator pattern, can allow for very loose coupling
#    between a family of related objects and behaviors.

# Subject / Publisher
# -------------------

# Let's separate publisher behavior into a module so it can be composed:
module Publisher
  def listeners
    @listeners ||= []
  end

  def subscribe(listener)
    listeners << listener
  end

  def publish(event, *args)
    listeners.each { |listener| listener.send(event, *args)}
  end
end

class StockIndex
  attr_reader :name, :index

  include Publisher

  def initialize(name, index=0)
    @name = name
    @index = index
  end

  def up(amount)
    @index += amount
    publish(:index_up, self, amount)
  end

  def down(amount)
    @index -= amount
    publish(:index_down, self, amount)
  end
end

# Observer / Subscriber / Listener
# --------------------------------

class NewsWire
  def index_up(index, amount)
    puts "#{index.name} is up #{amount} points!"
  end

  def index_down(index, amount)
    puts "#{index.name} is down #{amount} points!"
  end
end

# -----

nasdaq = StockIndex.new("NASDAQ", 5000)
nasdaq.subscribe(NewsWire.new)
nasdaq.up(500)
nasdaq.down(230)
