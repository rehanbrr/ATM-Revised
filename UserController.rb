require_relative 'user'
require_relative 'FileHandling'
require_relative 'validation'

module UserController
  include Validation

  def start_user_controller
    @file_system = FileSystem.new
    @file_system.load_user_data
    @user_data = @file_system.user_data
  end

  def get_emails
    @user_data.map do |user|
      user.email
    end
  end

  def get_usernames
    @user_data.map do |user|
        user.username
    end
  end

  def change_password(password)
    if @user
      @user.password = password
    end
  end

  def create_user(name, email, password, username)
    user = User.new(name, email, password, username)
    @user_data << user
  end

  def login_user(email, password)
    puts "this is userdata #{@user_data}"
    @user = @user_data.select {|user| user.email == email && user.password == password}
    puts "this is #{@user}"
    return true unless @user.nil?
  end
end