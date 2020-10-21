class RewardsController < ApplicationController

  def index
    @future_rewards, @past_rewards = Reward.all_split(Reward.sorted)
    @is_admin = user_is_admin?
    @user = current_user
  end

  def show
  end

  def new
    @reward = Reward.new
  end

  def create
    @reward = Reward.new(reward_params)

    if @reward.save && @reward.has_all_required_fields?
      flash[:notice] = "Reward created successfully"
      redirect_to(rewards_path)
    else
      flash[:notice] = "Inocrrect fields"
      render('new')
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end
  
  def reward_params
    params.require(:reward).permit(:name, :description, :points_required, :when)
  end
  
end
