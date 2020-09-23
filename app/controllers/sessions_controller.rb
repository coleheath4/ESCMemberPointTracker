class SessionsController < ApplicationController
  
  def create
  	@user = User.find_or_create_from_auth(request.env["omniauth.auth"])
  	session[:user_id] = @user.id
  	redirect_to :me
  end

  def default_create
    if params[:username].present? && params[:password].present?
      found_user = User.where(:username => params[:username]).first

      if found_user
        found_user = found_user.authenticate(params[:password])
      end
    end

    if found_user
      session[:user_id] = found_user.id
      flash[:notice] = "You are now logged in."
      redirect_to me_path
    else
      flash.now[:notice] = "Invalid username/password combination."
      render('signin/show')
    end
  end
  
  def destroy
  	session[:user_id] = nil
  	redirect_to signin_path
  end

end