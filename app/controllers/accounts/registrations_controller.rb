# frozen_string_literal: true

class Accounts::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up

  # POST /resource
  def create
    accountable = if params[:role][:role]=="Client"
        Client.new(client_params)
    elsif params[:role][:role]=="Freelancer"
       Freelancer.new(freelancer_params)
    end

    accountable.save

    puts accountable.id

    build_resource(sign_up_params)
    resource.name = params[:account][:name]
    resource.phone = params[:account][:phone]
    resource.gender = params[:account][:gender]

    resource.accountable_type=params[:role][:role].camelcase
    resource.linkedin=params[:account][:linkedin]
    resource.accountable_id = accountable.id
    resource.description=params[:account][:description]

    resource.save
    resource.image.attach(params[:account][:image])

    resource.save


    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if resource.client?
      my_projects_path
    elsif resource.freelancer?
      projects_path
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  private
  def client_params
    params.require(:client_attributes).permit(:company,:company_location)
  end


  def freelancer_params
    params.require(:freelancer_attributes).permit(:github,:experience)
  end

  def account_params
    params.require(:account).permit(:name,:gender,:phone,:image,:linkedin,:description)
  end

  def role_params
    params.require(:role).permit(:role)
  end

end
