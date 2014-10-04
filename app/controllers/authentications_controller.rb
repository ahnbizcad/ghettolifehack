class AuthenticationsController < Devise::OmniauthCallbacksController

  def all_providers
    omni = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])
    provider = omni['provider'].capitalize
    if user_signed_in? && authentication
      authentication.destroy
      flash[:notice] = "#{provider} dissociation successful." #ajaxify
      redirect_to edit_user_registration_path
    elsif current_user 
      current_user.apply_omniauth(omni)
      flash[:notice] = "#{provider} association successful."
      sign_in_and_redirect current_user
    elsif authentication
      user = User.find(authentication.user_id)   
      flash[:notice] = "Login with #{provider} successful." 
      sign_in_and_redirect user
    else # Not logged in and hasned logged in with a provider before.
      user = User.new
      user.apply_omniauth(omni)      
      if user.save
        flash[:notice] = "Login with #{provider} successful."  
        sign_in_and_redirect user
      else
        #, omniauth: omni.except('extra')
        flash[:alert] = "Please provide additional details for first-time registration."
        redirect_to new_user_registration_path(omni: omni.except('extra'))
        # Carry over email and nickname passed as params?
        # Currently email and name set in apply_omniauth() is caught by explicit value: option in new_user_registration_form.
        # Get rid of that and put it in custom catch form.
        # Will running it that way successfully override the model values set in apply_omniauth method?
        # Does that extra catch form page need extra work to work with Devise?
      end
    end

  end

  Authentication::SOCIALS.each do |k, _|
    alias_method k, :all_providers
  end

end
