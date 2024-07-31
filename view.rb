require_relative 'UserController'
require_relative 'AccountController'

CREATE_USER = 'create_user'
ALERT = {'email' => 'Email has to be unique and should contain .com and @. Try again',
        'password' => 'Password should me more than 8 character. Should contain numbers. Try again',
        'name' => 'Name should be more than 3 letters. Try again',
        'insufficient' => 'Insufficient Balance',
        'incorrect_login' => 'Login credentials incorrect!',
        'no_account' => 'No accounts available'}

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
    email = nil
    password = nil
    name = nil

    loop do
      if option == CREATE_USER
        puts 'Enter name:'
        name = gets.chomp
        valid_name = name_valid?(name)

        if valid_name != true
          puts ALERT['name']
          next
        end
      end
  
      puts 'Enter email:'
      email = gets.chomp
      option == CREATE_USER ? valid_email = email_valid?(email) : valid_email = true

      if valid_email != true
        puts ALERT['email']
        next
      end
  
      puts 'Enter password:'
      password = gets.chomp
      option == CREATE_USER ? valid_password = password_valid?(password) : valid_password = true

      if valid_password != true
        puts ALERT['password']
        next
      end

      validity = check_validitiy(valid_name, valid_email, valid_password)
      break if option == CREATE_USER && validity || option != CREATE_USER
    end
  
    option == CREATE_USER ? [name, email, password] : [email, password]
  end

  def check_validitiy(valid_name, valid_email, valid_password)
    valid_name == true && valid_email == true && valid_password == true
  end

  def password_change(user)
    puts 'Enter current password'
    current_password = get.chomp
    valid_password = false
    password_check(user, current_password)

    if password_check
      loop do
        puts 'Enter new password:'
        new_password = gets.chomp
        valid_password = password_valid?(password)

        if valid_password != true
          puts ALERT['password']
          next
        end

        change_password(new_password)
        puts 'Password changed!'
        break
      end
    end
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

  def get_balance(account)
    puts "\nBalance is: #{account.balance}"
  end

  def list_accounts(accounts)
    accounts.each_with_index do |account, index|
      account_digits = account.account_number.match(/\d{3}$/)
      puts "#{index + 1}. Account number ending with #{account_digits[0]}"
    end
    puts "0. Exit Menu"

    gets.chomp.to_i - 1
  end

  def sending_money(recipient, sender_account)
    recipient_accounts = find_user_accounts(recipient.email)
    return puts(ALERT['no_account']) if recipient_accounts.empty?
    
    amount = get_amount
    loop do
      choice = list_accounts(recipient_accounts)
      next if choice > recipient_accounts.size

      case choice
      when -1
        break
      else
        account = recipient_accounts[choice]       
        if !withdraw_money(sender_account, amount)
          puts ALERT['insufficient']
          next
        else
          deposit_money(account, amount)
          break
        end
      end
    end
  end

  def get_amount
    puts 'Enter Amount'
    gets.chomp.to_i
  end
  
  def start_menu
    #choices = {1 => "1. Create Account", 2 => "2. Login", 3 => "3. Exit"}

    loop do
        puts "\n\n1. Create User"
        puts '2. Login'
        puts '0. Exit'
  
      choice = gets.chomp.to_i
  
      case choice
      when 1
        name, email, password = get_user_params('create_user')
        create_and_add_user(name, email, password)
      when 2
        email, password = get_user_params('login')
        @user = login_user(email, password)

        puts ALERT['incorrect_login'] if !@user
        select_account_menu if @user
      when 0
        close_app
        break
      end
  
    end
  end

  def view_account_details(account)
    loop do
      puts "\n\nAccount details for #{account.account_number}"
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
        amount = get_amount
        puts ALERT['insufficient'] if !withdraw_money(account, amount)
        get_balance(account)
      when 3
        amount = get_amount
        deposit_money(account, amount)
        get_balance(account)
      when 4
        puts "Enter recipient's email:"
        email = gets.chomp
        user = find_user(email)
        user ? sending_money(user, account) : puts('User not found')
      when 5
        puts 'Account Deleted!' if delete_account(account)
        break
      when 0
        break
      end
    end
  end

  def view_accounts
    accounts = find_user_accounts(@user.email)
    return puts ALERT['no_account'] if !accounts

    loop do
      puts "\n\nAccount List"
      choice = list_accounts(accounts)
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
          puts "\nIncorrect PIN"
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
        puts "Account Created!" if create_account_and_add(pin, @user.email)
      when 2
        view_accounts
      when 3
        password_change(@user)
      when 0
        break
      end

    end

  end
end