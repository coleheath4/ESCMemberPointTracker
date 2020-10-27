# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate
  def index
    @is_admin = user_is_admin?
    @user = current_user
  end
end
