require_relative 'UserController'
require_relative 'AccountController'

ALERT = {'email' => 'Email has to be unique and should contain .com and @. Try again',
        'password' => 'Password should me more than 8 character. Should contain numbers. Try again',
        'name' => 'Name should be more than 3 letters. Try again',
        'insufficient' => 'Insufficient Balance',
        'incorrect_login' => 'Login credentials incorrect!',
        'no_account' => 'No accounts available'}

CHOICE = {'EXIT_LIST' => -1, 'EXIT' => 0, 'CREATE_USER' => 1, 'LOGIN' => 2, 
          'CREATE_ACCOUNT' => 1, 'VIEW_ACCOUNTS' => 2, 'CHANGE_PASSWORD' => 3,
          'CHECK_BALANCE' => 1, 'WITHDRAW' => 2, 'DEPOSIT' => 3, 'SEND_MONEY' => 4, 'DELETE_ACCOUNT' => 5}

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

  def get_login_params
    puts 'Enter email:'
    email = gets.chomp

    puts 'Enter password:'
    password = gets.chomp

    return email, password
  end

  def get_create_params
    email = nil
    password = nil
    name = nil

    loop do
      puts 'Enter name:'
      name = gets.chomp
      unless name_valid?(name)
        puts ALERT['name']
        next
      end

      puts 'Enter email:'
      email = gets.chomp
      unless email_valid?(email)
        puts ALERT['email']
        next
      end

      puts 'Enter password:'
      password = gets.chomp
      unless password_valid?(password)
        puts ALERT['password']
        next
      end

      break
    end

    return name, email, password
  end

  def password_change(user)
    puts 'Enter current password'
    current_password = gets.chomp
    valid_password = false

    if password_check(user, current_password)
      loop do
        puts 'Enter new password:'
        new_password = gets.chomp
        valid_password = password_valid?(new_password)

        unless valid_password == true
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
    puts "Total Amount: #{amount}"
    loop do
      choice = list_accounts(recipient_accounts)
      next if choice > recipient_accounts.size

      case choice
      when CHOICE['EXIT_LIST']
        break
      else
        account = recipient_accounts[choice]
        puts "Acoount detals: #{account}"
        unless withdraw_money(sender_account, amount)
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
    loop do
        puts "\n\n1. Create User"
        puts '2. Login'
        puts '0. Exit'
  
      choice = gets.chomp.to_i
  
      case choice
      when CHOICE['CREATE_USER']
        name, email, password = get_create_params()
        create_and_add_user(name, email, password)
      when CHOICE['LOGIN']
        email, password = get_login_params()
        @user = login_user(email, password)
        @user ? select_account_menu : puts(ALERT['incorrect_login'])
      when CHOICE['EXIT']
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
      when CHOICE['GET_BALANCE']
        get_balance(account)
      when CHOICE['WITHDRAW']
        amount = get_amount
        puts ALERT['insufficient'] unless withdraw_money(account, amount)
        get_balance(account)
      when CHOICE['DEPOSIT']
        amount = get_amount
        deposit_money(account, amount)
        get_balance(account)
      when CHOICE['SEND_MONEY']
        puts "Enter recipient's email:"
        email = gets.chomp
        user = find_user(email)
        user ? sending_money(user, account) : puts('User not found')
      when CHOICE['DELETE_ACCOUNT']
        puts 'Account Deleted!' if delete_account(account)
        break
      when CHOICE['EXIT']
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
      when CHOICE['EXIT_LIST']
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
      when CHOICE['CREATE_ACCOUNT']
        pin = get_account_params
        puts "Account Created!" if create_account_and_add(pin, @user.email)
      when CHOICE['VIEW_ACCOUNTS']
        view_accounts
      when CHOICE['CHANGE_PASSWORD']
        password_change(@user)
      when CHOICE['EXIT']
        break
      end
    end
  end
end