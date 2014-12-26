# ADAPTER (class/object structural pattern)
# =========================================

# GoF definition (p. 139):
# -----------------------
# "Convert the interface of a class into another interface clients expect.
# Adapter lets classes work together that couldn't otherwise because of 
# incompatible interfaces."

# Can be implemented either using inheritance (class pattern) or compostion 
# (object pattern); but I think composition should always be the preferred
# method.

# Also known as the 'wrapper' pattern.

# Pros:
# -----
#  * Enforces a consistent interface between two disparate objects.
#  * Separates interface from implementation.

# Cons:
# -----
#  * The adapter must necessarily be highly coupled to the adaptee.

# Adaptee:
# -------

# We will use the `Cipher` module as the adaptee.
# http://ruby-doc.org/stdlib-2.0/libdoc/openssl/rdoc/OpenSSL/Cipher.html

require 'openssl'

# Adapter:
# --------

class MessageEncrypter
  def initialize(cipher)
    # 'cipher' is the adaptee whose interface we will 'adapt'.
    # Note that we use dependency injection here, so
    # 'cipher' could be any object with the same interface.
    @cipher = cipher
    @key = cipher.random_key
    @init_vector = cipher.random_iv
  end

  # The public interface defined by this adapter:

  def encrypt(message)
    @cipher.encrypt
    parse_message(message)
  end

  def decrypt(message)
    @cipher.decrypt
    parse_message(message)
  end

  private

  def parse_message(message)
    @cipher.key = @key
    @cipher.iv = @init_vector
    @cipher.update(message) + @cipher.final
  end
end

# -----

cipher = OpenSSL::Cipher::AES256.new(:CFB)
encrypter = MessageEncrypter.new(cipher)

puts "Encrypting 'Hello, world.' =>"
encrypted_msg = encrypter.encrypt("Hello, world.")
puts "#{encrypted_msg}"
puts "Decrypting #{encrypted_msg} =>"
decrypted_msg = encrypter.encrypt(encrypted_msg)
puts "#{decrypted_msg}"
