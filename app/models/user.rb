class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Gravtastic
  has_gravatar :default=>"identicon"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_one_time_password
  enum otp_module: { disabled: 0, enabled: 1 }, _prefix: true
  attr_accessor :otp_code_token, :profile_pic
  has_one_attached :avatar

  # validations

  validates_presence_of :name, :username , on: :create
  validates :username, uniqueness: true

  #associations

  has_many :owned_groups, class_name:'Group', foreign_key: :owner_id, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members
  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def profile_pic
    if self.avatar.attached?
      self.avatar.service_url
    else
      self.gravatar_url
    end
  end


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  # Search users on the basis of credentials like name, username or email.
  def self.search_users(credential='')
    credentials = "%#{credential}%"
    where("name ILIKE :search OR username ILIKE :search OR email ILIKE :search", search: credentials)
  end

  # Find the list of groups to be populated in your groups section on the basis that user should be the owner of group or a member of group or the group is internal group.
  def your_groups(search_params)
    search_params[:name]||=""
    search_params[:sort_by]||=""
    search_params[:sort_by]=search_params[:sort_by].empty? ? "created_at desc" : search_params[:sort_by]
    Group.where("groups.id IN (
      SELECT groups.id FROM groups JOIN group_members on(group_members.group_id=groups.id)
      where group_members.user_id=:user_id and
      (group_members.expiration_date>now()::date or group_members.expiration_date is null)
      and groups.name ILIKE :search)
      OR groups.id IN (SELECT groups.id from groups where owner_id=:user_id and name ILIKE :search)
      OR groups.id IN (SELECT groups.id from groups where visibility = 1 and name ILIKE :search)",
       search: "%#{search_params[:name].strip}%", user_id: self.id).order(search_params[:sort_by])
  end

  # Find recently visited groups on the basis of visit count
  def find_frequent_groups
    self.groups.includes(:group_members)
    .where("group_members.visit_count<>0")
    .order("group_members.visit_count desc")
    .limit(5)
  end
end
