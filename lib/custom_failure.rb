class CustomFailure < Devise::FailureApp
  def redirect_url
    if params[:controller]=="sessions" and params[:action]=="create"
      "/users/sign_in?message=Invalid Login or Password&message_type=failure"
    else
      "/users/sign_in"
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end