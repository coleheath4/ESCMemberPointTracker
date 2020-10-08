class UsersController < ApplicationController
  before_action :authenticate

  def index
    if user_is_admin?
      @users = User.sorted
    else
      redirect_to(dashboard_path)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "User created successfully"
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
      flash[:notice] = "User updated successfully"
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

  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :is_admin, :username, :email, :points)
  end

end
