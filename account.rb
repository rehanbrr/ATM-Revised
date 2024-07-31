class Account
  attr_accessor :pin, :balance, :email

  def initialize(pin, email)
    @pin = pin
    @email = email
    @balance = 0
  end

  def withdraw(amount)
    @balance = @balance.to_i - amount
  end

  def deposit(amount)
    @balance = @balance.to_i + amount
  end
end