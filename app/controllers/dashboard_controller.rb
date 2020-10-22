class DashboardController < ApplicationController
  before_action :authenticate
  def index
    if user_is_admin?
      
    end
  end
end
