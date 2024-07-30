require_relative 'user'
require_relative 'account'
require 'CSV'
class FileSystem

  attr_accessor :user_data, :account_data

  def load_user_data
    file_name = 'users.csv'
    return File.new(file_name, 'w+') if !File.exist?(file_name)

    user_data = CSV.open(file_name, 'r').readlines
    puts "user data csv: #{user_data}"
    @user_data = user_data.inject({}) do |hash, user_params|
      user = User.new(user_params[0], user_params[1], user_params[2])
      hash[user.email] = user
      hash
    end

  end

  def load_account_data
    file_name = 'accounts.csv'
    return File.new(file_name, 'w+') if !File.exist?(file_name)

    account_data = CSV.open(file_name, 'r').readlines
    puts "CSV data: #{account_data}"
    @account_data = account_data.inject({}) do |hash, account_params|
      account = Account.new(account_params[0], account_params[1])
      account.balance = account_params[2]
      hash[account.email] ||= []
      hash[account.email] << account
      hash
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