# CHAIN OF RESPONSIBILITY (object behavioral pattern)
# ===================================================

# GoF definition (p. 223):
# ------------------------
# "Avoid coupling the sender of a request to its receiver by giving more than # one object a chance to handle the request. Chain the receiving objects and 
# pass the request along the chain until the object handles it."

# If a Handler cannot handle a given request, it automatically passes it on to 
# its defined successor, until one of the handlers on the chain handles the
# request.

# Pros:
# -----
#  * Allows for an 'implicit receiver' – the client that sends the request has 
#  no knowledge of what will ultimately handle it, nor does it need to.

# Cons:
# -----
#  * The 'chain' of handlers may grow unwieldy and difficult to track.

# Module to make objects ('handlers') chainable:
# ----------------------------------------------

module Chainable
  def next_in_chain(successor)
    @successor = successor
  end

  def method_missing(method, *args, &block)
    raise "End of chain" if @successor.nil?
    @successor.send(method, *args, &block) # pass request to successor
  end
end

# Handlers:
# ---------

class Secretary
  include Chainable

  def conduct_diplomacy
    puts "Let's make a deal."
  end
end

class VicePresident
  include Chainable

  def vote_in_senate
    puts "Aye!"
  end
end

class President
  include Chainable

  def launch_nukes
    puts "YAHOOOOO! Launching nukes!"
  end
end

# -----

kerry = Secretary.new
biden = VicePresident.new
obama = President.new

kerry.next_in_chain(biden) # Building the chain of responsibility
biden.next_in_chain(obama)

kerry.launch_nukes # => Passed up chain to 'obama'
kerry.world_peace # => Raises 'End of Chain' error; no handler can do this :(
