class RegistrationsController < Devise::RegistrationsController
#Override some Devise methods

  # Pre-populates form upon failure.
  # Don't set value options in registration forms
  def build_resource(*args)
    super
    if params[:omni]
      @user.apply_omniauth(params[:omni])
      @user.valid?  
    end
  end

  def create
    super
    
    # Clear session if session was used to pass params across pages
    #session[:omniauth] = nil unless @user.new_record?
  end

  #def catch
  #  resource = "awer"
  #  omni = params['omni']
  #  user = User.new.apply_omniauth(omni)
  #end

end