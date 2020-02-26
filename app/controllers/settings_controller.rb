class SettingsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery except: :index

  def index
  end
end
