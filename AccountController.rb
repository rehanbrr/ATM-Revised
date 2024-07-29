require_relative 'FileHandling'
require_relative 'validation'
require_relative 'account'

module AccountController
  include Validation

  def start_account_controller
    @file_system = FileSystem.new
    @file_system.load_account_data
    @account_data = @file_system.account_data
  end

  def create_account(pin, username)
    account = Account.new(pin, username)
    @account_data << account
  end

  def find_user_accounts(username)
    accounts = @account_data.select {|account| account.username == username}

    return accounts
  end
end