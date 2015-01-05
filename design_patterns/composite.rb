# COMPOSITE (object structural pattern)
# =====================================

# GoF definition (p. 163):
# -----------------------
# "Compose objects into tree structures to represent part-whole hierarchies.
# Composite lets clients treat individual objects and compositions of objects
# uniformly."

# The key to this pattern is that it allows clients to ignore the difference
# between compositions of objects and individual objects. When a request is 
# sent down the tree, if the recipient is a single object, the request is
# handled directly. If the recipient is a composite object, it forwards the
# request to its children. The client does not and should not know whether
# they are dealing with individual objects or composite objects.

# Pros:
# -----
#  * Clients can treat composite and individual objects uniformly.
#  * It is easy to create new kinds of components.

# Cons:
# -----
#  * Component design can be overly generalized, making it difficult to
#    distinguish between different types of components

# Component (defines interface):
# ------------------------------

class AbstractNode
  def ping
    raise NotImplementedError
  end

  def add(node)
    raise NotImplementedError
  end

  def remove(node)
    raise NotImplementedError
  end

  def nodes
    raise NotImplementedError
  end
end

# 'Leaf' (individual node):
# -------------------------

class Node < AbstractNode
  def ping
    puts "pong!"
  end

  def add(node)
    raise NodeError, "Not a node cluster"
  end

  def remove(node)
    raise NodeError, "Not a node cluster"
  end

  def nodes
    raise NodeError, "Not a node cluster"
  end
end

class NodeError < StandardError
end

# Composite (group of nodes):
# ---------------------------

class NodeCluster < AbstractNode
  def initialize
    @nodes = []
  end

  # This request is forwarded to all children
  def ping
    @nodes.each { |n| n.ping }
  end

  def add(node)
    @nodes << node
  end

  def remove(node)
    @nodes.reject { |n| n == node }
  end

  def nodes
    @nodes
  end
end

# -----

root = NodeCluster.new
root.add(Node.new)
root.add(Node.new)
root.add(NodeCluster.new)
root.nodes.last.add(Node.new)
root.ping # should print 'pong!' 3 times, one for each Node
