module ApplicationHelper
  def matches_current_user?(user)
    if user_signed_in?
      current_user == user
    else
      false
    end
  end
  
end
