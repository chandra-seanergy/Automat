class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :frequent_groups, only: [:new, :edit, :show]
  before_action :find_group, only: [:edit, :show, :delete_group, :update]

  def new
  end

  def edit
    render template: "groups/edit.html.erb", locals: {group: @group}
  end

  def create
    group, group_avatar = Group.new(group_params), params[:group][:avatar]
    group.owner_id = current_user.id
    group.avatar = group_avatar if !group_avatar.nil? and File.exist?(group_avatar) #Add Avatar attribute only if valid file exists in params
    if group.save
      render json: {status: 200, message: "Group created successfully.", group: group}
    else
      render json:{status: 500, message: group.errors.full_messages}
    end
  end

  def show
    GroupMember.update_visit_count(@group, current_user)
    render template: "groups/show.html.erb", locals: {group: @group}
  end

  # Delete group from database
  def delete_group
    if @group.destroy
      render json: {status: 200, message: "Group deleted successfully.", group: @group}
    else
      render json: {status: 500, message: @group.errors.full_messages}
    end
  end

  # Update Group Attributes
  def update
    group_avatar = params[:group][:avatar]
    @group.avatar = group_avatar if !group_avatar.nil? and File.exist?(group_avatar)
    if @group.update(group_params)
      render json: {status: 200, message: "Group updated successfully.", avatar: @group.avatar.url}
    else
      render json:{status: 500, message: @group.errors.full_messages}
    end
  end

  # groups created by the current user
  def owned_groups
    owned_groups = current_user.owned_groups
    render json: {status: 200, owned_groups: owned_groups.pluck(:name)}
  end

  private

  # Allow only Strong parameters to be passed to model
  def group_params
    params.require(:group).permit(:name, :description, :visibility, :avatar)
  end

  # Find groups on the basis of id recieved in parameter
  def find_group
    @group = Group.find_by(id: params[:id])
    redirect_to "#{root_path(current_user)}?message=Group requested does not exists&message_type=failure" unless @group
  end
end
