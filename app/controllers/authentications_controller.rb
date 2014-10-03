class AuthenticationsController < Devise::OmniauthCallbacksController

# # Fat controller. Move biz logic to model.
# def twitter
#   omni = request.env["omniauth.auth"]
#   authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])

#   if authentication 
#     # If already registered previously
#     flash[:notice] = "Logged in successfully."      
#     user = User.find(authentication.user_id)
#     sign_in_and_redirect user
#   elsif current_user 
#     # If signed in via any other strategy, including devise.      
#     current_user.authentications.create!(:provider => omni['provider'], 
#                                          :uid => omni['uid'], 
#                                          :token => token = omni['credentials']['token'],
#                                          :token_secret => omni['credentials']['secret'])
#     flash[:notice] = "Authentication successful."
#     sign_in_and_redirect current_user
#   else
#     # If brand new to the site.
#     user = User.new
#     user.apply_omniauth(omni)
#     
#     if user.save
#       flash[:notice] = "Login successful."
#       sign_in_and_redirect User.find(user.id)
#     else
#       session[:omniauth] = omni.except('extra')
#       params[:email] = "test"
#       redirect_to new_user_registration_path
#     end
#   end

# end

  def all_providers
    omni = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])
    provider = omni['provider'].capitalize
    if user_signed_in? && authentication
      authentication.destroy
      redirect_to edit_user_registration_path, notice:  "#{provider} dissociation successful." #ajaxify
    elsif current_user 
      current_user.apply_omniauth(omni)  
      sign_in_and_redirect current_user, notice: "#{provider} association successful."
    elsif authentication
      user = User.find(authentication.user_id)      
      sign_in_and_redirect user, notice: "Login with #{provider} successful." 
    else # Not logged in and hasned logged in with a provider before.
      user = User.new
      user.apply_omniauth(omni)      
      if user.save        
        sign_in_and_redirect user, notice: "Login successful."
      else
        session[:omniauth] = omni.except('extra')
        #params[:email] = omni['info']['email']
        redirect_to new_user_registration_path(email: omni['info']['email'])
      end
    end

  end

  Authentication::SOCIALS.each do |k, _|
    alias_method k, :all_providers
  end

end
