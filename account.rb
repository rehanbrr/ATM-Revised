class Account
  attr_accessor :pin, :balance, :email, :account_number

  def initialize(account_number, pin, email)
    @account_number = account_number
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