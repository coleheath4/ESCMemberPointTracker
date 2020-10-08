class DashboardController < ApplicationController
  before_action :authenticate
  def index
    if user_is_admin?
      redirect_to(users_path)
    end
  end
end
