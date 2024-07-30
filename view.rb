require_relative 'UserController'
require_relative 'AccountController'

class Machine
  include UserController
  include AccountController

  def start
    start_user_controller
    start_account_controller
    puts 'Welcome to ATM'
    start_menu
    puts 'Goodbye!'
  end

  def close_app
    store_user_data
    store_account_data
  end
  
  def get_user_params(option)
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

        if valid_name == false
          puts 'Name should be more than 3 letters. Try again'
          next
        end

      end
  
      puts 'Enter email:'
      email = gets.chomp
      valid_email = !email_valid?(email) if option == 'createuser'

      if valid_email == false
        puts 'Email has to be unique and should contain .com and @. Try again'
        next
      end
  
      puts 'Enter password:'
      password = gets.chomp
      valid_password = password_valid?(password)

      if valid_password == false
        puts 'Password should me more than 8 character. Should contain numbers. Try again'
        next
      end
  
      puts valid_email
      puts valid_name
      puts valid_password
      break if break_condition(valid_name, valid_email, valid_password, option)
    end
  
    if option == 'createuser'
      return name, email, password
    else
      return email, password
    end
  end
  
  def break_condition(valid_name, valid_email, valid_password, option)
    if option == 'createuser'
      if(valid_name == true && valid_email == true && valid_password == true)
        return true
      else
        return false
      end

    elsif option == 'login'
      return true
    end

  end
  
  def start_menu
    #choices = {1 => "Create Account", 2 => "Login", 3 => "Exit"}

    loop do
        puts '1. Create User'
        puts '2. Login'
        puts '3. Exit'
  
      choice = gets.chomp.to_i
  
      case choice
      when 1
        name, email, password = get_user_params('createuser')
        create_and_add_user(name, email, password)
      when 2
        email, password = get_user_params('login')
        user = user if login_user(email, password) == true
      when 3
        close_app
        break
      end
  
    end
  end

  def get_account_params
    pin = ''
    loop do
      puts 'Enter PIN (4 Digits)'
      pin = gets.chomp.to_i
      
      break if pin_valid?(pin)
    end
  end

  def select_account_menu
    
    loop do
      puts '1. Create Account'
      puts '2. View Accounts'
      puts '3. Logout'

      choice = gets.chomp.to_i

      case choice
      when 1 
        pin, email = get_account_params
        create_account(pin, email)
      when 2
        email = get_current_email
        accounts = find_user_accounts(email)

        accounts.each.with_index do |account, index|
          pin_digits = pin.match(/\d{2}$/)
          puts "#{index + 1}. Account with PIN ending with #{pin_digits[0]}"
        end
      when 3
        break
      end

    end

  end
end