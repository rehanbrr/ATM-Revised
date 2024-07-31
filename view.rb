require_relative 'UserController'
require_relative 'AccountController'

class Machine
  include UserController
  include AccountController

  def start
    start_user_controller
    start_account_controller
    puts "\n\nWelcome to ATM"
    start_menu
    puts 'Goodbye!'
  end

  def close_app
    store_user_data
    store_account_data
  end
  
  def get_user_params(option) #will refactor this soon
    valid_name = false
    valid_email = false
    valid_password = false

    if option == 'login'
      valid_email = true
      valid_password = true
    end
  
    email = nil
    password = nil
    name = nil

    loop do
      if option == 'createuser'
        puts 'Enter name:'
        name = gets.chomp
        valid_name = name_valid?(name)

        if valid_name != true
          puts 'Name should be more than 3 letters. Try again'
          next
        end

      end
  
      puts 'Enter email:'
      email = gets.chomp
      valid_email = email_valid?(email) if option == 'createuser'

      if valid_email != true
        puts 'Email has to be unique and should contain .com and @. Try again'
        next
      end
  
      puts 'Enter password:'
      password = gets.chomp
      valid_password = password_valid?(password)

      if valid_password != true
        puts 'Password should me more than 8 character. Should contain numbers. Try again'
        next
      end

      validity = check_validitiy(valid_name, valid_email, valid_password)
      break if break_condition(validity, option)
    end
  
    option == 'createuser' ? [name, email, password] : [email, password]
  end

  def check_validitiy(valid_name, valid_email, valid_password)
    valid_name == true && valid_email == true && valid_password == true
  end
  
  def break_condition(validity, option)
    return option == 'createuser' && validity || option == 'login'
  end

  def get_account_params
    pin = ''
    loop do
      puts 'Enter PIN (4 Digits)'
      pin = gets.chomp
      
      break if pin_valid?(pin)
    end

    pin
  end
  
  def start_menu
    choices = {1 => "1. Create Account", 2 => "2. Login", 3 => "3. Exit"}

    loop do
        puts "\n\n1. Create User"
        puts '2. Login'
        puts '0. Exit'
  
      choice = gets.chomp.to_i
  
      case choice
      when 1
        name, email, password = get_user_params('createuser')
        create_and_add_user(name, email, password)
      when 2
        email, password = get_user_params('login')
        @user = login_user(email, password)

        puts 'Login credentials incorrect' if !@user
        select_account_menu if @user
      when 0
        close_app
        break
      end
  
    end
  end

  def get_balance(account)
    puts "Balance is: #{account.balance}"
  end

  def view_account_details(account)
    loop do
      puts "\n\nAccount details for #{account.pin}"
      puts "1. Check Balance"
      puts "2. Withdraw Money"
      puts "3. Deposit Money"
      puts "4. Send Money"
      puts "5. Delete this account"
      puts "0. Exit"

      choice = gets.chomp.to_i

      case choice
      when 1
        get_balance(account)
      when 2
        puts 'Enter amount'
        amount = gets.chomp.to_i
        puts 'Insufficient Balance' if !withdraw_money(account, amount)
        get_balance(account)
      when 3
        puts 'Enter amount'
        amount = gets.chomp.to_i
        deposit_money(account, amount)
        get_balance(account)
      when 4

      when 5
        puts 'Account Deleted!' if delete_account(account)
        break
      when 0
        break
      end
    end
  end

  def view_accounts
    puts "\n\nAccount List"
    accounts = find_user_accounts(@user.email)
    return puts "No accounts available" if !accounts

    loop do
      accounts.each.with_index do |account, index|
        pin_digits = account.pin.match(/\d{2}$/)
        puts "#{index + 1}. Account with PIN ending with #{pin_digits[0]}"
      end
      puts "0. Exit Menu"

      choice = gets.chomp.to_i - 1

      next if choice > accounts.size

      case choice
      when -1
        break
      else
        puts 'Enter PIN for account'
        pin = gets.chomp
        account = accounts[choice]
        if account.pin == pin
          view_account_details(account)
        else
          puts 'Incorrect PIN'
        end        
      end
    end
  end

  def select_account_menu
    loop do
      puts "\n\nChoose an option: "
      puts '1. Create Account'
      puts '2. View Accounts'
      puts '3. Change Password'
      puts '0. Logout'

      choice = gets.chomp.to_i

      case choice
      when 1 
        pin = get_account_params
        create_account_and_add(pin, @user.email) if !pin_existence?(pin, @user.email)
      when 2
        view_accounts
      when 3
        
      when 0
        break
      end

    end

  end
end