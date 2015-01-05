# FLYWEIGHT (object structural pattern)
# =====================================

# GoF definition (p. 195):
# -----------------------
# "Use sharing to support large numbers of fine-grained objects efficiently."

# The key to grasping this pattern is to understand the distinction between intrinsic and extrinsic state:

# 1. Intrinsic state is independent of an object's context,
# 2. Extrinsic state depends on and varies with an object's context.

# The flyweight pattern aims to reduce the number of objects needed in a system
# by moving all intrinsic state into a pool of 'flyweight' objects that can be
# shared. 

# In this example, rather than instantiate an object for every single character
# in a sentence, the sentence relies on a pool of flyweight 'character' objects
# that store the character's intrinsic state (i.e. what latter it represents).
# This way there is only one character object for every letter in the
# alphabet, rather than one object for every single character in the document.

# While this pattern can reduce storage requirements in certain cases,
# the pattern is only useful under the following conditions:

#   * Storage costs are high because of sheer object quantity,
#   * Many groups of objects may be replaced by relatively few shared objects
#     once extrinsic state is removed.

# Pros:
# -----
#  * Can greatly reduce storage requirements of an application

# Cons:
# -----
#  * Requires the separation of intrinsic and extrinsic state, which
#    can be a source of confusion when we are accustomed to encapsulated
#    objects.

# Flyweight
# ---------

class Letter
  attr_accessor :char

  def initialize(char)
    @char = char # This is intrinsic state, e.g. 'j' is always 'j'
  end
end

# Flyweight factory (stores and creates flyweights)
# -------------------------------------------------

class Alphabet
  attr_accessor :letter_pool

  def initialize(letter_class)
    @letter_pool = {}
    @letter_class = letter_class
  end

  def get_letter(char)
    if @letter_pool[char]
      # Retrieve the letter if it already exists
      @letter_pool[char]
    else
      # Otherwise add it too the pool
      @letter_pool[char] = @letter_class.new(char)
    end
  end
end

# Client object
# -------------

class Document
  def initialize(alphabet)
    @alphabet = alphabet
    @content = []
    # Some 'extrinsic state' for letters
    # Here it is just pseudocode, but by way of example:
    @font_size = 12
    @font = 'Helvetica'
  end

  def add_letter(char)
    # Our flyweight factory 'alphabet' stores and shares a pool
    # of all possible letters, so we don't have to create letter
    # objects for every single character in @content.
    @content.push(@alphabet.get_letter(char))
  end

  def remove_letter
    @content.pop
  end

  def print
    printed_content = ""
    @content.each { |letter| printed_content += letter.char }
    puts printed_content
  end
end

# -----

latin_alphabet = Alphabet.new(Letter)
my_doc = Document.new(latin_alphabet)
my_doc.add_letter("H")
my_doc.add_letter("e")
my_doc.add_letter("l")
my_doc.add_letter("l")
my_doc.add_letter("o")
my_doc.add_letter(" ")
my_doc.add_letter("W")
my_doc.add_letter("o")
my_doc.add_letter("r")
my_doc.add_letter("l")
my_doc.add_letter("d")
my_doc.print # => 'Hello world'

# Note that the pool has only one 'o' letter object, though it appears twice in
# the document. This is the benefit of using flyweights:
p latin_alphabet.letter_pool 
