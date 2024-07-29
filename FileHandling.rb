require_relative 'user'
require_relative 'account'

class FileSystem

  attr_accessor :user_data, :account_data

  def load_user_data
    file_name = 'users.csv'
    if File.exist?(file_name)
      user_file = File.open(file_name, 'r')
      user_data = user_file.readlines
      user_file.close
      @user_data = []

      for user_line in user_data
        user_params = user_line.split(',')
        user = User.new(user_params[0], user_params[1], user_params[2], user_params[3])
        @user_data << user
      end
    else
      File.new(file_name, 'w+')
      return nil
    end

  end

  def save_user_data(user)
    file_name = 'users.csv'
    if File.exist?(file_name)
      user_file = File.open(file_name, 'a')
      user_file.puts("#{user.name},#{user.email},#{user.password},#{user.username}")
      user_file.close()
    end

  end

  def load_account_data
    file_name = 'accounts.csv'

    if File.exist?(file_name)
      account_file = File.open(file_name, 'r')
      account_data = account_file.readlines
      account_file.close()
      @account_data = []

      for account_line in account_data
        account_params = account_line.split(',')
        account = Account.new(account_params[0], account_params[1], account[2])
        @account_data << account
      end
    else
      File.new(file_name, 'w+')
      return nil
    end

  end

  def save_account_data(account)
    file_name = 'accounts.csv'
    if File.exist?(file_name)
      account_file = File.open(file_name, 'a')
      account_file.puts("#{account.pin},#{account.username},#{account.balance}")
      account_file.close()
    end
    
  end
end