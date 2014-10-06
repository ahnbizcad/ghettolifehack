class RegistrationsController < Devise::RegistrationsController
#Override some Devise methods
  
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      flash[:alert] = "Please review the problems below." # Different from original
      respond_with resource
    end
  end
 
  # Attempt to not require password for non-password fields (and so do without breaking anything else)
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

  # # Different from original
  # if self.resource.current_password_required?(params)
  #   resource_updated = update_resource(resource, account_update_params)
  # else
  #   resource_updated = self.resource.update_attributes(account_update_params)
  # end


    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      flash[:alert] = "Please review the problems below." # Different from original
      respond_with resource
    end
  end

  protected

    # Pre-populates form upon failure to sign in or register
    # Internally calls new_with_session, but authentication needs to be built also.
    def build_resource(*args)
      super
      if session["devise.omni"]
        @user.apply_omniauth(session["devise.omni"])
        @user.valid?
      end
    end

    # Set redirect path after updating to edit path
    def after_update_path_for(resource)
      edit_user_registration_path
    end

end