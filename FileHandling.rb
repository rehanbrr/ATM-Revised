require_relative 'user'
require_relative 'account'

class FileSystem

  attr_accessor :user_data, :account_data

  def load_user_data
    file_name = 'users.csv'
    if File.exist?(file_name)
      user_data = File.open(file_name, 'r').readlines
      @user_data = {}

      for user_line in user_data
        user_params = user_line.split(',')
        user = User.new(user_params[0], user_params[1], user_params[2])
        @user_data[user.email] = user
      end

    else

      File.new(file_name, 'w+')
    end

  end

  def load_account_data
    file_name = 'accounts.csv'
  
    if File.exist?(file_name)
      account_data = File.open(file_name, 'r').readlines
      @account_data = {}
  
      account_data.each do |account_line|
        account_params = account_line.split(',')
        account = Account.new(account_params[0], account_params[1])
        account.balance = account_params[2]
        
        if @account_data.key?(account.email)
          @account_data[account.email] << account
        else
          @account_data[account.email] = [account]
        end
      end
    else
      File.new(file_name, 'w+')
    end
  end
  

  def update_user_files(user_data)
    file_name = 'users.csv'
    user_file = File.open(file_name, 'w')
    keys = user_data.keys

    for key in keys
      user = user_data[key]
      user_file.puts("#{user.name},#{user.email},#{user.password}")
    end

    user_file.close()
  end

  def update_account_files(account_data)
    file_name = 'accounts.csv'
    account_file = File.open(file_name, 'w')
    keys = account_data.keys

    for key in keys
      for account in account_data[key]
        account_file.puts("#{account.pin},#{account.email},#{account.balance}")
      end
    end

    account_file.close
  end
end