class ProfilesController < ApplicationController
  before_action :authenticate_user!
  # udpate_profile
  def update_profile
    # user_avatar = params[:user][:avatar]
    # current_user.avatar = user_avatar if !user_avatar.nil? and File.exist?(user_avatar)
    if current_user.update(profile_params)
      render json: {status: 200, message: "Profile Updated Successfully.", avatar: current_user.avatar.service_url}
    else
      render json: {status: 500, message: current_user.errors.full_messages}
    end
  end

  # Display current user profile
  def my_profile
    if current_user.avatar.attached?
      avatar = current_user.avatar.service_url
    else
      avatar = nil
    end
    render json: { user: current_user.as_json(except: :avatar), avatar: avatar}
  end

  # Display the users profile
  def show
    user = User.find_by(id: params[:id])
    if user
      render json: {status: 200, user: user}
    else
      render json: {status: 500, message: user.errors.full_messages}
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email, :public_email, :commit_email, :skype,
      :linkedin, :twitter, :website_url, :location, :organization, :bio, :private_profile,
      :private_contributions, :avatar)
    end
  end
