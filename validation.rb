module Validation
  def email_valid?(email)
    if email.include?('@') && email.include?('.com') && !email.include?(',')
      return true if !@user_data.key?(email)
    end
    
  end
  
  def password_valid?(password)
    true if password =~ /^(?=.*\d)[^,]{9,}$/
  end
  
  def name_valid?(name)
    name.length > 3 && !name.include?(',')
  end

  def pin_valid?(pin)
    if pin.match?(/^\d{4}$/)
      return true
    end

    return false
  end
end