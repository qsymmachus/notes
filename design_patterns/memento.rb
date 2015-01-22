# MEMENTO (object behavioral pattern)
# ===================================

# GoF definition (p. 283):
# -----------------------
# "Without violating encapsulation, capture and externalize an object's
# internal state so that the object can be restored to this state later."

# Originator
#  * creates a memento storing a snapshot of its internal state.
#  * uses a memento to restore its internal state.

# Memento
#  * stores the internal state of an originator.
#  * protects against access by objects other than the originator
#    (How, exactly? Is this maintaing encapsulation in this way strictly
#    necessary?)

# Caretaker
#  * Stores mementos


# Pros:
# -----
#  * Memento avoids exposing information that only an originator should manage,
#    but must nevertheless be exposed outside the originator.
#  * Allows you to easily restore the previous state of an originator.
#  * Mementos can serve as a 'change log'.

# Cons:
# -----
#  * Can quickly become expensive, especially if storing the state of the
#    originator requires a lot of memory.

# Originator
# ----------

class Document
  attr_accessor :text

  def initialize(text="")
    @text = text
  end

  def get_state
    TextMemento.new(@text)
  end

  def restore_state(memento)
    @text = memento.text
  end
end

# Memento
# -------

class TextMemento
  attr_reader :text

  def initialize(text)
    @text = text
  end
end

# Caretaker
# ---------

class DocumentHistory
  attr_accessor :history

  def initialize
    @history = []
  end

  def push(memento)
    @history.push(memento)
  end

  def pop
    @history.pop
  end
end

# -----

doc_history = DocumentHistory.new

my_doc = Document.new("This is the old text!")
doc_history.push(my_doc.get_state)
puts my_doc.text

my_doc.text = "This is some new text!"
puts my_doc.text

# restoring the old state from the memento:
my_doc.restore_state(doc_history.pop)
puts my_doc.text
