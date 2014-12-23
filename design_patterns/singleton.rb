# SINGLETON (object creational pattern)
# =====================================

# GoF definition (p. 127):
# ------------------------
# "Ensure a class only has one instance, and provide a global point of access
# to it."
#
# Sometimes a design calls for only one instance of a class. Rather than
# pollute the namespace with a globally scoped instance, use the singleton
# pattern to enforce single instance requirement.

# Singleton:
# ----------

require 'singleton'

class Logger
  include Singleton # ruby includes a library for this pattern
  attr_reader :logs

  def initialize
    @logs = {}
  end

  def log(message)
    @logs[Time.now] = message
  end
end

# -----

# This would throw an error:
# my_logger = Logger.new 

my_logger = Logger.instance # This returns the single instance

my_logger.log("Hello, world")
p my_logger.logs
