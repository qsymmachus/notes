# COMMAND (object behavioral pattern)
# ===================================

# GoF definition (p. 233):
# -----------------------
# "Encapsulate a request as an object, thereby letting you parameterize
# clients with different requests, queue or log requests, and support
# undoable operations."

# The key to this pattern is that it decouples the object that invokes an
# operation (the 'invoker') from the object having the knowledge to perform
# it (the 'command'). In this respect it is similar to the strategy pattern.

# Famously, this pattern can allow for undoable operations. If a command
# provides a means to reverse its operations (e.g. an 'unexecute' method
# as well as 'execute'), command objects can be stored in a history list
# and 'undone' and 'redone' with this methods.

# Pros:
# -----
#  * Decouples the object that invokes the operation from the one that knows
#    how to perform it.
#  * You can assemble commands into a composite command.
#  * You can support undoable operations.

# Abstract Command [defines interface]
# ------------------------------------

class Command
  def execute
    raise NotImplementedError
  end

  def unexecute
    raise NotImplementedError
  end
end

# Concrete Commands
# -----------------

class CreateFile < Command
  def initialize(path, data)
    @path = path
    @data = data
  end

  def execute
    file = File.open(@path, 'w')
    file.write(@data)
    file.close
  end

  def unexecute
    File.delete(@path)
  end
end

class CompositeCommand < Command
  def initialize(commands=[])
    @commands = commands
  end

  def execute
    @commands.each { |command| command.execute }
  end

  def unexecute
    @commands.each { |command| command.unexecute }
  end

  def add_command(command)
    @commands << command
  end
end

# -----

create_some_files = CompositeCommand.new
create_some_files.add_command(CreateFile.new('./EN.txt', 'hello'))
create_some_files.add_command(CreateFile.new('./FR.txt', 'bonjour'))
create_some_files.add_command(CreateFile.new('./ES.txt', 'hola'))

create_some_files.execute
puts "\nLOCAL DIRECTORY AFTER FILES CREATED:"
puts "===================================="
puts Dir.entries('.')

create_some_files.unexecute
puts "\nLOCAL DIRECTORY AFTER FILES DELETED:"
puts "===================================="
puts Dir.entries('.')
