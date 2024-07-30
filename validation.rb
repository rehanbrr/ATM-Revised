module Validation
  def email_valid?(email)
    if email.include?('@') and email.include?('.com') and !email.include?(',')
      return @user_data[key] if @user_data.key?(email)
    end
    
  end
  
  def password_valid?(password)
    true if password =~ /^(?=.*\d)[^,]{9,}$/
  end
  
  def name_valid?(name)
    if name.length < 3 and !name.include?(',')
      return false
    end
    
    return true
  end

  def pin_valid?(pin)
    if pin.match?(/^\d{4}$/)
      return true
    end

    return false
  end
end