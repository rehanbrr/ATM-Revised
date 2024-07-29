class User
  attr_accessor :name, :password, :email, :username

  def initialize(name, email, password, username)
    @name = name
    @password = password
    @email = email
    @username = username
  end
end
