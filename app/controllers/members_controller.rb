class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :frequent_groups, only: [:group_members]
  before_action :find_group, except: [:user_list, :group_members]
  before_action :group_member, only: [:delete_member]

  # Display list of all members in the group 
  def member_list
    group_members = @group.get_member_list(member_params)
    render json: {status: 200, message: "Member list fetched successfully.", members: group_members}
  end

  # Add Member to Group
  def create
    member = GroupMember.bulk_add_hash(member_params)
    if GroupMember.import!(member)
      render json: {status: 201, message: "Members added successfully.", member: member}
    else
      render json: {status: 500, message: member.errors.full_messages}
    end
  end

  # Remove Member from Group
  def delete_member
    if @group_member.destroy
      render json: {status: 200, message: "User was successfully removed from group and any subresources."}
    else
      render json: {status: 500, message: member.errors.full_messages }
    end
  end

  # API to accept parameters of credentials and return list of Users
  def user_list
    users = User.search_users(params[:credential])
    render json: {status: 200, message: "member list fecthed successfully.", members: response_list_users(users)}
  end

  def group_members
    @group = Group.find_by(id: params[:group_id])
    render template: "members/group_members.html.erb", locals: {group: @group}
  end

  private
  # Find group based on group id
  def find_group
    @group = Group.find_by(id: params[:group_member][:group_id])
    render json: {status: 500, message: "No record found."} unless @group
  end

  # Allow only strong parameters to be used for Model Interaction
  def member_params
    params.require(:group_member).permit(:group_id, :member_type, :credential, :sort_by, :expiration_date, :user_id => [])
  end

  # Validate before removing that whether a user is already removed or not
  def group_member
    @group_member = GroupMember.find_by(group_id: @group.id, user_id: params[:group_member][:user_id])
    render json: {status: 500, message: "Member already removed."} unless @group_member
  end

  def response_list_users(list)
    # list.map{|x| x.attributes.merge(avatar: x.profile_pic)}
    list.map{|x| x.attributes.merge(avatar: "")}
  end
end
