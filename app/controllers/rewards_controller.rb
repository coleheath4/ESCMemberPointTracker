# frozen_string_literal: true

class RewardsController < ApplicationController
  def index
    @future_rewards, @past_rewards = Reward.all_split(Reward.sorted)
    @is_admin = user_is_admin?
    @user = current_user
  end

  def show
    @is_admin = user_is_admin?
    @user = current_user
    @reward = Reward.find(params[:id])
  end

  def eligible
    @is_admin = user_is_admin?
    @user = current_user
    @rewards = Reward.eligible_list(Reward.sorted, @user)
    @is_admin = user_is_admin?
  end

  def new
    @is_admin = user_is_admin?

    redirect_to(rewards_path) unless @is_admin

    @reward = Reward.new
  end

  def create
    @is_admin = user_is_admin?
    @reward = Reward.new(reward_params)

    if @reward.save && @reward.has_all_required_fields?
      flash[:notice] = 'Reward created successfully'
      redirect_to(rewards_path)
    else
      @reward.destroy
      flash[:alert] = 'Event Name, Points, and Event Date are required.'
      render('new')
    end
  end

  def edit
    @is_admin = user_is_admin?

    redirect_to(reward_path) unless @is_admin

    @reward = Reward.find(params[:id])
  end

  def update
    @is_admin = user_is_admin?
    @reward = Reward.find(params[:id])

    if @reward.update_attributes(reward_params)
      flash[:notice] = 'Reward has been updated'
      redirect_to(reward_path(@reward))
    else
      flash[:alert] = 'Reward could not be updated'
      redirect_to(edit_reward_path(@reward))
    end
  end

  def delete
    @is_admin = user_is_admin?

    redirect_to(reward_path) unless @is_admin

    @reward = Reward.find(params[:id])
  end

  def destroy
    @is_admin = user_is_admin?
    @reward = Reward.find(params[:id])
    reward_name = @reward.name
    if @reward.destroy
      flash[:notice] = "Reward #{reward_name} destroyed successfully"
      redirect_to(rewards_path)
    end
  end

  def delete_rewards
    @is_admin = user_is_admin?
    redirect_to(rewards_path) unless @is_admin
    Reward.destroy_all
    flash[:notice] = 'Rewards cleared successfully'
    redirect_to(rewards_path)
  end

  def delete_rewards_warning
    @is_admin = user_is_admin?
    redirect_to(rewards_path) unless @is_admin
  end

  def reward_params
    params.require(:reward).permit(:name, :description, :points_required, :when)
  end
end
