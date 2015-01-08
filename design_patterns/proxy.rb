# PROXY (object structural pattern)
# =================================

# GoF definition (p. 207):
# -----------------------
# "Provide a surrogate or placeholder for another object to control access to
# it."

# A Proxy must do the following:
#   * maintain a reference that lets the proxy access the real subject
#   * provide an interface identical to the subject's
#   * control access to the real subject

# The two most common types of proxies are:
#
# 1. Remote proxy - provides a local representative for an object in a
#    address space.
#
# 2. Virtual proxy – serves as a placeholder for more expensive objects.
#
# 3. Protection proxy – controls access to the original object.

# Pros:
# -----
#  * A remote proxy can hide the fact that an object is not stored locally.
#  * A virtual proxy can create more complicated objects on demand.

# Subject 
# -------

class BankAccount
  def initialize(balance)
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
  end 

  def withdraw(amount)
    @balance -= amount
  end

  def balance
    @balance
  end
end

# Proxy (in this example, a protection proxy)
# -------------------------------------------

class AccountProtectionProxy
  def initialize(real_account, password)
    @subject = real_account
    @password = password
  end

  def deposit(amount)
    check_password
    @subject.deposit(amount)
  end 

  def withdraw(amount)
    check_password
    @subject.withdraw(amount)
  end

  def balance
    check_password
    @subject.balance
  end

  private

  def check_password
    puts "Password:"
    password = gets.chomp
    raise "Invalid password" unless password == @password
  end
end

# -----
my_account = BankAccount.new(1000)
proxy = AccountProtectionProxy.new(my_account, "supersecret")
proxy.withdraw(100)
puts proxy.balance
