module Validation
  def email_valid?(email)
    if email.include?('@') && email.include?('.com')
      return true if !@user_data.key?(email)
    end

  end
  
  def password_valid?(password)
    true if password =~ /^(?=.*\d)[^,]{9,}$/
  end
  
  def name_valid?(name)
    name.length > 3
  end

  def pin_valid?(pin)
    pin.match?(/^\d{4}$/)   
  end
  
end
