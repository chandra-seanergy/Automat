class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  has_one_time_password
  enum otp_module: { disabled: 0, enabled: 1 }, _prefix: true
  attr_accessor :otp_code_token, :profile_pic

  # validations

  validates_presence_of :name, :username , on: :create
  validates :username, uniqueness: true
end
