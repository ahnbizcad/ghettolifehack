module ApplicationHelper
  
  def currently_admin?
    if user_signed_in?
      current_user.admin? ? true : false
    else
      false
    end
  end

  def matches_current_user?(user)
    if user_signed_in?
      current_user == user
    else
      false
    end
  end

  def avatar_url(user, size=48)
    default_url = "#{root_url}/images/gravatar_default.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}" 
  end

  def hide_elements?
    (controller_name == 'registrations') ||
    (controller_name == 'users') ||
    (controller_name == 'sessions')
  end


end
