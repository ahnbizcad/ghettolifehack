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

  def hide_sidebar?
    (controller_name == 'registrations') ||
    (controller_name == 'users') ||
    (controller_name == 'sessions')
  end

end
