require_relative 'FileHandling'
require_relative 'validation'
require_relative 'account'

module AccountController
  include Validation

  def start_account_controller
    @file_system = FileSystem.new
    @file_system.load_account_data
    @account_data = @file_system.account_data
    puts "this is account data loaded: #{@account_data}"
  end

  def store_account_data
    @file_system.update_account_files(@account_data)
  end

  def create_account(pin, email)
    Account.new(pin, email)
  end

  def add_account(account)
    @account_data[account.email] ? @account_data[account.email] << account : @account_data[account.email] = [account]
  end

  def create_account_and_add(pin, email)
    account = create_account(pin, email)
    add_account(account)
  end

  def validate_user(pin, account)
    user_accounts = find_user_accounts(account.email)
    user_accounts.find {|user_account| user_account.pin == pin}
  end

  def pin_existence?(pin, email)
    accounts = find_user_accounts(email)
    accounts.detect {|account| account.pin == pin} if accounts
  end

  def find_user_accounts(email)
    accounts = @account_data[email]
  end

  def withdraw_money(account, amount)
    amount > account.balance.to_i ? false : account.withdraw(amount)
  end

  def deposit_money(account, amount)
    account.deposit(amount)
  end

  def delete_account(account)
    user_accounts = find_user_accounts(account.email)
    account_index = user_accounts.find_index {|user_account, index| user_account == account}
    user_accounts.delete_at(account_index)
  end
end