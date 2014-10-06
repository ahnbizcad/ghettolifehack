class AuthenticationsController < Devise::OmniauthCallbacksController

  def all_providers
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    provider = omniauth['provider'].capitalize
    if user_signed_in? && authentication
      if current_user.encrypted_password.blank? && current_user.authentications.size <= 1
        flash[:alert] = "Please set a password before dissociating your social media account so that you can log back in."
        redirect_to edit_user_registration_path
      else
        authentication.destroy
        flash[:notice] = "Successfully dissociated #{provider} from your #{@title} account." #ajaxify
        redirect_to edit_user_registration_path
      end
    elsif current_user
      current_user.authentications.create!(
        provider: omniauth['provider'],
        uid: omniauth['uid'],
        token: omniauth['credentials']['token'],
        token_secret: omniauth['credentials']['secret'],
      )
      flash[:notice] = "Successfully associated #{provider} with your #{@title} account."
      redirect_to edit_user_registration_path
    elsif authentication # fails
      user = User.find(authentication.user_id) 
      flash[:notice] = "Login with #{provider} successful."
      sign_in_and_redirect user
    else # Not logged in and hasned logged in with a provider before.
      user = User.new
      user.apply_omniauth(omniauth)  
      if user.save
        flash[:notice] = "Login with #{provider} successful."
        sign_in_and_redirect user
      else
        session["devise.omni"] = omniauth.except('extra') # Hash key prepended with 'devise' to auto clear session after login.
        flash[:notice] = "Please provide additional details for first-time registrations. "
        flash[:notice] << "If you already have an account, please first log in, then associate your social media account."
        redirect_to new_user_registration_path()
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
