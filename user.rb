class User
  attr_accessor :name, :password, :email
  
  def initialize(name, email, password)
    @name = name
    @password = password
    @email = email
  end
end
