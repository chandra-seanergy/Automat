class ConfirmationsController < Devise::ConfirmationsController
  respond_to :json
  def almost_there

  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: {status: 200, message: "Confirmation Email Sent Successfully"}
    else
      render json: {status: 500, message: resource.errors.full_messages.first}
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource){ redirect_to "#{after_confirmation_path_for(resource_name, resource)}?message=Account Confirmed Successfully&message_type=success" }
    else
      redirect_to "#{new_user_session_path}?message=Account is already confirmed&message_type=failure"
    end
  end
end
