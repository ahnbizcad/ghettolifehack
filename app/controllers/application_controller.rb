class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, :except => :create

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :title

  protected

    # Devise strong parameters
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up)        { |u| u.permit(:email, :password, :password_confirmation, :username) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :username, :current_password) }
    end

    def timed_out?(object, time=5*60)
      (Time.now.utc - object.created_at) > time ? true : false
    end    
    helper_method :timed_out?

    def favorited_by_current_user?(hack)
      if user_signed_in?
        if hack.favorites.find_by(user_id: current_user.id)#.where(favorites: { user_id: current_user.id}).references(:favorites)
          true
        else
          false
        end
      else
        false
      end
    end
    helper_method :favorited_by_current_user?

  private
  
    def title
      @title = "Ghetto Lifehack"
    end

end
