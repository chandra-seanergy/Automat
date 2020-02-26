class PasswordsController < ApplicationController
  respond_to :json
  before_action :require_no_authentication, only: [:create, :update]
  before_action :authenticate_user!, only: [:forgot_password, :change_password]
  before_action :validate_password, only: [:change_password]

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      render json: {status: 200, message: "If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes."}
    else
      render json: {status: 500, message: resource.errors.full_messages.first}
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: "#{after_resetting_password_path_for(resource)}?message=Your password has been changed successfully&message_type=success"
    else
      set_minimum_password_length
      redirect_to "#{new_user_session_path}?message=Password Reset Link is Expired&message_type=failure"
    end
  end

  # API to resend mail with reset password instruction in case the user click on forgot password
  def forgot_password
    current_user.send_reset_password_instructions
    render json: {status: 200, message: "We sent you an email with reset password instructions"}
  end

  # Change User Password if he request to change it
  def change_password
    if current_user.update(password: params[:user][:new_password])
      render json: {status: 200, message: "Your password has been changed successfully."}
    else
      render json: {status: 500, message: current_user.errors.full_messages}
    end
  end

  private

  # Validate password at the time of delete account
  def validate_password
    render json: {status: 500, message: "Invalid Current Password"} unless current_user.valid_password?(params[:user][:password])
  end
end
