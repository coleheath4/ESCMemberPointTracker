# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate

  def index
    if user_is_admin?
      @users = User.sorted

      respond_to do |format|
        format.html
        format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" }
      end
    else
      redirect_to(dashboard_path)
    end
  end

  def show
    if user_is_admin?
      @user = User.find(params[:id])
    else
      redirect_to(dashboard_path)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'User created successfully'
      redirect_to(users_path)
    else
      render('new')
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:notice] = 'User updated successfully'
      redirect_to(user_path(@user))
    else
      render('edit')
    end
  end

  def delete
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "User '#{@user.username}' destroyed successfully"
    redirect_to(users_path)
  end

  def delete_all_users
    @users = User.non_admin_list(User.sorted)
    User.where(is_admin: false).destroy_all
    flash[:notice] = 'Users cleared successfully'
    redirect_to(users_path)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :is_admin, :username, :email, :points)
  end
end
