class GroupMember < ApplicationRecord
  enum member_type: { guest: 0, reporter: 1, developer: 2, maintainer: 3, owner: 4, primary_owner: 5 }
  #validations
  validates_presence_of :user_id, :group_id , on: :create

  #associations
  belongs_to :user
  belongs_to :group

  # Remove Already added members to avoid remapping and returns a common hash values for bulk addition of members
  def self.bulk_add_hash(member_params)
  	group=Group.find_by_id(member_params[:group_id])
  	member_params[:user_id]-=[group.owner_id]
  	GroupMember.where("group_id=? and user_id in (?)",group.id,member_params[:user_id]).destroy_all
  	members = []
    member_params[:user_id].each do |user_id|
    	members<<{group_id: group.id, user_id: user_id, member_type: member_params[:member_type].to_i, expiration_date: member_params[:expiration_date]}
    end
    email_ids=User.where("id in (?)", member_params[:user_id]).pluck(:email)
    MemberMailer.success_add(group, self.member_types.key(member_params[:member_type].to_i).camelcase, email_ids).deliver_now
    return members
  end

  # Update User's Group Visit Count everytime he opens a group
  def self.update_visit_count(group, current_user)
  	group_member = self.find_by(group: group, user: current_user)
  	group_member.update(visit_count: group_member.visit_count+1) if group_member
  end
end