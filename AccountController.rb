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

  def store_account_data
    @file_system.update_account_files(@account_data)
  end

  def create_account(pin, email)
    account = Account.new(pin, email)
    @account_data << account
  end

  def find_user_accounts(email)
    accounts = @account_data.select {|account| account.email == email}
  end
end