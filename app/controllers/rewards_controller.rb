class RewardsController < ApplicationController

  def index
    @future_rewards, @past_rewards = Reward.all_split(Reward.sorted)
    @is_admin = user_is_admin?
    @user = current_user
  end

  def show
    @user = current_user
    @reward = Reward.find(params[:id])
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
      @reward.destroy
      flash[:alert] = "Event Name, Points, and Event Date are required."
      render('new')
    end
  end

  def edit
    @reward = Reward.find(params[:id])
  end

  def update
    @reward = Reward.find(params[:id])
    
    if @reward.update_attributes(reward_params)
      flash[:notice] = "Reward has been updated"
      redirect_to(reward_path(@reward))
    else
      flash[:alert] = "Reward could not be updated"
      redirect_to(edit_reward_path(@reward))
    end
  end

  def delete
    @reward = Reward.find(params[:id])
  end

  def destroy
    @reward = Reward.find(params[:id])
    reward_name = @reward.name
    if @reward.destroy
        flash[:notice] = "Reward " + reward_name + " destroyed successfully"
      redirect_to(rewards_path)
    end
  end
  
  def reward_params
    params.require(:reward).permit(:name, :description, :points_required, :when)
  end
  
end
