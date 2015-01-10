# ITERATOR (object behavioral pattern)
# ====================================

# GoF definition (p. 257):
# -----------------------
# "Provide a way to access the elements of an aggregate object sequentially
# without exposing its underlying representation."

# As the GoF put it, "the key idea in this pattern is to take the
# responsibility for access and traversal out of the list object and put it
# into an iterator object (p. 257)."

# At a minimum, an iterator usually provides the following interface for its
# aggregator:
#   * first
#   * next
#   * is_done [i.e. it has reached the last item in the aggregate]
#   * current_item

# An 'external' iterator allows the client to control iteration directly. An
# 'internal' iterator hides traversal logic from the public interface.

# Pros:
# -----
#  * Supports variations in the traversal of an aggregate by substituting
#    different concrete iterators.
#  * Simplifies the interface of an aggregate and makes it composable.
#  * Allows polymorphic iteration (a type of subtype/inclusion polymorphism)

# Iterator
# --------

module InternalIterator
  def for_each
    list_copy = Array.new(@list)
    index = 0
    while index < list_copy.length
      yield list_copy[index]
      index += 1
    end
  end
end

# Aggregate/Enumerable
# --------------------

class List
  include InternalIterator

  def initialize(list = Array.new)
    @list = list
  end
end

# -----

my_list = List.new([1,2,3,4,5])
my_list.for_each { |item| puts item * 2 }
