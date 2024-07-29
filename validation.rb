module Validation
  def email_valid?(email)
    emails = get_emails
    if email.include?('@') and email.include?('.com') and !email.include?(',')
      return emails.any? {|taken_email| taken_email == email}
    end
    
    return true
  end
  
  def password_valid?(password)
    if password.length > 8 and password =~ /\d/ and !password.include?(',')
      return true
    end
  
    return false
  end
  
  def username_valid?(username)
    usernames = get_usernames
    if username.length >= 8 and !username.include?(',')
      
      return usernames.any? {|user| user == username}
    end
  
    return true
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