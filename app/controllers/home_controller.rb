class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :frequent_groups, only: [:index]
  
  def index
  end
end
