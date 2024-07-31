require_relative 'FileHandling'
require_relative 'validation'
require_relative 'account'

module AccountController
  include Validation

  def start_account_controller
    @file_system = FileSystem.new
    @file_system.load_account_data
    @account_data = @file_system.account_data
    @account_numbers = @file_system.account_numbers
    puts "this is account data loaded: #{@account_data}"
  end

  def store_account_data
    @file_system.update_account_files(@account_data)
  end

  def create_account(account_number, pin, email)
    Account.new(account_number, pin, email)
  end

  def add_account(account)
    @account_data[account.email] ||= []
    @account_data[account.email] << account
  end

  def generate_account_number
    account_number = 0
    loop do
      account_number = rand(10000...99999).to_s
      break unless @account_numbers.include?(account_number)
    end
    account_number
  end

  def create_account_and_add(pin, email)
    account = create_account(generate_account_number, pin, email)
    add_account(account)
  end

  def validate_user(pin, account)
    user_accounts = find_user_accounts(account.email)
    user_accounts.find {|user_account| user_account.pin == pin}
  end

  def find_user_accounts(email)
    @account_data[email]
  end

  def withdraw_money(account, amount)
    return if amount > account.balance.to_i
    account.withdraw(amount) 
  end

  def deposit_money(account, amount)
    account.deposit(amount)
  end

  def delete_account(account)
    user_accounts = find_user_accounts(account.email)
    user_accounts.delete_if {|user_account| user_account == account}
  end
end