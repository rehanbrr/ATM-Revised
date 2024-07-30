class Account
  attr_accessor :pin, :balance, :email

  def initialize(pin, email)
    @pin = pin
    @email = email
    @balance = 0
  end
end