# BRIDGE (object structural pattern)
# ==================================

# GoF definition (p. 151):
# -----------------------
# "Decouple abstraction [interface] from its implementation so that the two
# can vary independently."

# This is very similar to the adapter pattern; the chief difference one of 
# motivation: the adapter pattern is geared toward making unrelated classes
# work together through a predictable interface, while the bridge pattern
# is designed up front to separate implementation and interface into two
# parallel class hierarchies.

# Pros:
# -----
#  * Separates interface from implementation
#  * Implementations are interchangeable

# Cons:
# -----
#  * The interface and implementation classes must be tightly coupled.

# Abstraction [interface]:
# ------------------------

class RoboChat
  attr_accessor :robot

  def initialize(robot)
    # 'robot' is our "implementor"
    # Note that we use dependency injection here, so
    # 'robot' could be any object with the same interface.
    @robot = robot
  end

  def chat
    puts @robot.greeting
    message = ""
    until @robot.says_goodbye?(message)
      puts "=> "
      message = gets.chomp
      puts @robot.respond(message)
    end
  end
end

# Implementor [implementation]:
# -----------------------------

# Abstract superclass
class Robot
  def greeting
    "I am an abstract superclass."
  end

  def respond(message)
    raise NotImplementedError
  end
end

# Concrete subclass
class DumbRobot < Robot
  RESPONSES = [
    "That's an interesting point. Could you explain further?",
    "I don't understand what you mean by that.",
    "You do realize my responses are random, right?",
    "Please help computer."
  ]

  def greeting
    "Hello! I am not very good at chatting."
  end

  # Here is the core method used by RoboChat#chat
  # Note that RoboChat is ignorant of its implementation.
  def respond(message)
    RESPONSES.sample
  end

  def says_goodbye?(message)
    /^.*goodbye.*$/.match(message.downcase)
  end
end

# -----
chat_room = RoboChat.new(DumbRobot.new)
chat_room.chat
