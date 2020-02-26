class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
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
        respond_with resource, location: users_almost_there_path
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      redirect_to new_user_session_path
    end
  end

  # validate email exist in database
  def email_exist
    user = User.find_for_database_authentication(email: params[:user][:email])
    if user
      render json: {status: 500, message: "Email is already taken."}
    else
      render json: {status: 200, message: "Email is available."}
    end
  end

  # validate username exist in database
  def username_exist
    user = User.find_for_database_authentication(username: params[:user][:username])
    if user
      render json: {status: 500, message: "Username is already taken."}
    else
      render json: {status: 200, message: "Username is available."}
    end
  end
end
