class SessionsController < ApplicationController

  before_action :find_user, only: [:login, :verify_otp]
  before_action :validate_password, only: [:login]
  before_action :confirmed_user, only: [:login]
  # POST /resource/sign_in
  def login
    if resource.otp_module_disabled?
      login_after_validation
      redirect_to root_path(resource)
    else
      two_factor_authenticate(resource, "", "")
    end
  end

  # Verify OTP if two factor authentication enabled
  def verify_otp
    user_otp = params[:user][:otp_code]
    if  user_otp.size > 0 && resource.authenticate_otp(user_otp, drift: 60)
      login_after_validation
      redirect_to root_path(resource)
    else
      two_factor_authenticate(resource, "Invalid OTP Code", "failure")
    end
  end

  def two_factor_authenticate(resource, message, message_type)
    render template: "devise/sessions/two_factor_authenticate.html.erb", locals:{resource: resource, message: message, message_type: message_type}
  end

  private

  def find_user
    user_credentials = params[:user][:login]
    self.resource = User.find_for_database_authentication(login: user_credentials)
    redirect_to "#{new_user_session_path}?message=Invalid Login or Password&message_type=failure" unless resource
  end

  # Validate password at the time of log in
  def validate_password
    redirect_to "#{new_user_session_path}?message=Invalid Login or Password&message_type=failure" unless resource.valid_password?(params[:user][:password])
  end

  # Validates if the user logging in has confirmed his mail or not
  def confirmed_user
    redirect_to "#{new_user_session_path}?message=Please confirm your email&message_type=failure" unless resource.confirmed?
  end

  def login_after_validation
    resource.after_database_authentication
    sign_in(resource_name, resource)
  end
end
