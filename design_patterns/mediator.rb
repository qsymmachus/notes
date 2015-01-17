# MEDIATOR (object behavioral pattern)
# ====================================

# GoF definition (p. 273):
# -----------------------
# "Define an object that encapsulates how a set of objects interact. Mediator
# promotoes loose coupling by keeping objects from referring to each other
# explicitly, and it lets you vary their interaction independently."

# The mediator serves as an intermediary that keeps objects the work together
# from referring to each other explicitly – they only refer to the mediator,
# which alone has knowledge of the group.

# Pros:
# -----
#  * Promotes loose coupling between colleagues.
#  * Abstracts how colleagues collaborate – encapsulating how objects interact #    in a separate object allows you to focus on how objects interact apart 
#    from their individual behavior.

# Cons:
# -----
#  * As more behavior is delegated to the mediator, it can become unwieldy and
#    difficult to maintain.

# Colleagues
# ----------

class Tweeter
  attr_accessor :email

  def initialize(email)
    @messages = []
    @mediator = TweeterWatcher.new
    @email = email
  end

  def post_message(message)
    @messages.push(message)
    @mediator.message_posted(self)
  end

  def latest_message
    @messages.last
  end
end

class TweeterMailer
  def mail(args)
    puts "TO: #{args[:to]} MESSAGE: #{args[:message]}"
  end
end

# Mediator
# --------

class TweeterWatcher
  def initialize
    @mailer = TweeterMailer.new
  end

  def message_posted(tweeter)
    @mailer.mail({
      to: tweeter.email,
      message: tweeter.latest_message
    })
    # Maybe do some other stuff - update followers, parse for hashtags, etc.
    # This "collaboration" behavior is encapsulated within the mediator so the
    # colleagues can focus on their own focused behaviors.
  end
end

# -----
my_tweeter_account = Tweeter.new("me@example.com")
my_tweeter_account.post_message("Hello, world")
