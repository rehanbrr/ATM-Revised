class Account
  attr_accessor :pin, :balance, :username

  def initialize(pin, username)
    @pin = pin
    @username = username
    @balance = 0
  end
end