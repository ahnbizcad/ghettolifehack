class AuthenticationsController < Devise::OmniauthCallbacksController

  def twitter
    omni = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])

    if authentication 
      # If already registered previously
      flash[:notice] = "Logged in successfully."      
      user = User.find(authentication.user_id)
      sign_in_and_redirect user
    elsif current_user 
      # If signed in via any other strategy, including devise.
      
      current_user.authentications.create!(:provider => omni['provider'], 
                                           :uid => omni['uid'], 
                                           :token => token = omni['credentials']['token'],
                                           :token_secret => omni['credentials']['secret'])
      flash[:notice] = "Authentication successful."
      sign_in_and_redirect current_user
    else
      # If brand new to the site.
      user = User.new
      user.apply_omniauth(omni)
      
      if user.save
        flash[:notice] = "Login successful."
        sign_in_and_redirect User.find(user.id)
      else
        session[:omniauth] = omni.except('extra')
        redirect_to new_user_registration_path
      end
    end

  end


  #################################
  #def twitter
  #  @user = User.from_omniauth(request.env["omniauth.auth"])
  #  if @user.persisted?
  #    sign_in_and_redirect @user, event: authentication
  #    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #  else
  #    session["devise.facebook_data"] = request.env["omniauth.auth"]
  #    redirect_to new_user_registration_url
  #  end
  #end


########################
#
#  def all
#    user = User.from_omniauth(env['omniauth.auth'], current_user)
#    if user.persisted?
#      sign_in_and_redirect user
#      flash[:notice] = t('devise.omniauth_callbacks.success', :kind => User::SOCIALS[params[:action].to_sym])
#      #if user.sign_in_count == 1
#      #  redirect_to first_login_path
#      #else
#      #  redirect_to cabinet_path
#      #end
#    else
#      session['devise.user_attributes'] = user.attributes
#      redirect_to new_user_registration_url
#    end
#  end
#
#  User::SOCIALS.each do |k, _|
#    alias_method k, :all
#  end
#
#  def failure
#
#  end


end
