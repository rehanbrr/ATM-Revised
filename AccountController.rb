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
    if @account_data.key?(account.email)
      @account_data[account.email] << account
    else
      @account_data[account.email] = [account]
    end

    puts "account data after adding: #{@account_data}"
  end

  def create_account_and_add(pin, email)
    puts "pin in adding: #{pin}"
    account = create_account(pin, email)
    add_account(account)
  end

  def find_user_accounts(email)
    accounts = @account_data[email]
  end
end