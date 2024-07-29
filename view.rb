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
  
  def get_user_params(option)
    valid_name = false
    valid_username = false
    valid_email = false
    valid_password = false

    if option == 'login'
      valid_email = true
      valid_password = true
    end
  
    email = nil
    password = nil
    name = nil
    username = nil

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
  
      if option == 'createuser'
        puts 'Enter username:'
        username = gets.chomp
        valid_username = !username_valid?(username)

        if valid_username == false
          puts 'Username has to be more than 3 letters and unique. Try again'
          next
        end

      end
  
      break if break_condition(valid_name, valid_email, valid_password, valid_username, option)
    end
  
    if option == 'createuser'
      return name, email, password, username
    else
      return email, password
    end
  end
  
  def break_condition(valid_name, valid_email, valid_password, valid_username, option)
    if option == 'createuser'
      if(valid_name == true && valid_email == true && valid_password == true && valid_username == true)
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
        name, email, password, username = get_user_params('createuser')
        create_user(name, email, password, username)
      when 2
        email, password = get_user_params('login')
        puts "Logged In!"  if login_user(email, password) == true
        account_menu
      when 3
        update_files
      end
  
    end
  end

  def get_account_params
    create_account
  end

  def select_account_menu
    
    loop do
      puts '1. Create Account'
      puts '2. View Accounts'
      puts '3. Logout'

      choice = gets.chomp.to_i

      case choice
      when 1

      end
    end

  end
end