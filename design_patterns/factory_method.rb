# FACTORY METHOD (pattern type)
# ============================================

# GoF definition (p. 107):
# -----------------------
# "Define an interface for creating an object, but let subclasses decide which
# class to instantiate. Factory Method lets a class defer instantiation to 
# subclasses."

# Extra notes

# Pros:
# -----
#  * Allows for more flexible, subclass-specific methods of object creation.
#  * The abstract factory method defines a clear interface the enforces 
#    certain requirements on subclasses factory methods.

# Cons:
# -----
#  * Can require creation of new subclasses to implement minor differences
#    in object creation.

# Abstract class
# --------------

class Package
  class << self
    STANDARD_RATE = 1.50
    EXPRESS_RATE = 3.50

    def prepare_standard(weight) # A factory method
      postage = weight * STANDARD_RATE
      new(postage) # Class of instance is deferred to subclasses
    end

    def prepare_express(weight) # Another factory method
      postage = weight * EXPRESS_RATE
      new(postage)
    end

    # make 'new' private so Packages must be instantiated with factory methods
    private :new 
  end

  attr_reader :postage

  def initialize(postage)
    @postage = postage
  end
end

# Concrete class
# --------------

class HazardousPackage < Package
  class << self
    STANDARD_RATE = 3.00
    EXPRESS_RATE = 7.00

    # Factory methods are inherited, and since they did not specify
    # the instantiated class of Package, they can be used without
    # further modification.
  end
end

# -----

# Since we made '.new' private, this would throw an error
# HazardousPackage.new(5)

standard_ebola_sample = HazardousPackage.prepare_standard(5)
puts standard_ebola_sample.postage

express_ebola_sample = HazardousPackage.prepare_express(5)
puts express_ebola_sample.postage
