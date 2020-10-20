class RewardsController < ApplicationController

  def index
    @rewards = Reward.sorted
    @is_admin = user_is_admin?
    @user = current_user
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end
  
end
