class GroupListingController < ApplicationController
  before_action :authenticate_user!
  before_action :frequent_groups, only: [:group_list]

  # Fetch list of all groups where the visibility is public
  def public_groups
    groups = Group.find_public_groups(search_params)
    render json: {status: 200, message: "Group list feched successfully.", groups: response_list_groups(groups)}
  end

  # Fetch list of all groups where the visibility is internal
  def internal_groups
    groups = Group.find_internal_groups(search_params)
    render json: {status: 200, message: "Group list feched successfully.", groups: response_list_groups(groups)}
  end

  # API To fetch all groups where the user is owner or is a member of
  def your_groups
    all_groups = current_user.your_groups(search_params)
    render json: {status: 200, message: "Group list feched successfully.", groups: response_list_groups(all_groups)}
  end

  def group_list
    params[:is_public] ||= "false"
    is_public=params[:is_public]
    render template: "group_listing/group_list.html.erb", locals: {is_public: is_public}
  end

  private
  # Allow parameters to be passed to model for search and sort filters
  def search_params
    params.permit(:name, :sort_by)
  end
  # Reduce Code redundancy by creating common method for common response json
  def response_list_groups(list)
    #list.map{|x| x.attributes.merge(avatar: x.avatar.url, member_count: x.group_members.length)}
    list.map{|x| x.attributes.merge(avatar: "", member_count: x.group_members.length)}
  end
end
