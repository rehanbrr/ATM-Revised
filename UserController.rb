require_relative 'user'
require_relative 'FileHandling'
require_relative 'validation'

module UserController
  include Validation

  def start_user_controller
    @file_system = FileSystem.new
    @file_system.load_user_data
    @user_data = {}
    @user_data = @file_system.user_data
    puts "this is user data loaded: #{@user_data}"
  end

  def store_user_data
    @file_system.update_user_files(@user_data)
  end

  def get_current_email
    @user.email
  end

  def change_password(password)
    if @user
      @user&.password = password
    end
  end

  def create_user(name, email, password)
    User.new(name, email, password)
  end

  def add_user(user)
    @user_data = {user.email => user}
  end

  def create_and_add_user(name, email, password)
    user = create_user(name, email, password)
    add_user(user)
  end

  def login_user(email, password)
    @user = @user_data[email] if @user_data.key?(email)
  end
end