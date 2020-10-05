class SessionsController < ApplicationController
  
  def create
  	@user = User.find_or_create_from_auth(request.env["omniauth.auth"])
    if @user.created_at == @user.updated_at
      session[:email] = @user.email
      session[:first_name] = @user.first_name
      session[:last_name] = @user.last_name
      session[:uid] = @user.uid
      session[:provider] = @user.provider
      redirect_to(register_path) and return
    end
    session[:user_id] = @user.id
  	redirect_to :dashboard
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
      redirect_to dashboard_path
    else
      flash.now[:notice] = "Invalid username/password combination."
      render('signin/show')
    end
  end
  
  def register_create
    puts "PARAMS: "
    puts params

    if params[:user].present?
      keys = ['email', 'first_name', 'last_name', 'uid', 'provider']

      u = params[:user]

      keys.each do |k|
        if u[k].present?
          params[k] = u[k]
        end
      end
    end
    
    if params_are_found?(params, ['username', 'password', 'password_confirm', 'email', 'first_name', 'last_name'])
      if !(User.where(email: params[:email]).first || User.where(username: params[:username]).first) && params[:password].eql?(params[:password_confirm])
          u = User.new
          u.username = params[:username]
          u.password = params[:password]
          u.email = params[:email]
          u.first_name = params[:first_name]
          u.last_name = params[:last_name]
          u.points = 0
          u.is_admin = false

          u.uid = params[:uid]
          u.uid = params[:provider]
          
          u.save!

          puts 'In this operation here!'
          
          session[:user_id] = u.id
          redirect_to(dashboard_path)
      else
        puts 'Error'
        redirect_to(register_path)
      end
    else
      puts "This is not supposed to happen"
    end

  end
  
  def destroy
    session[:user_id] = nil
    cookies.delete :user_token
  	redirect_to signin_path
  end

  def params_are_found?(params, items)

    items.each do |n|
      puts 'This val n'
      puts n
      if !params[n].present?
        puts 'Not present'
        return false
      end
      puts 'Present'
    end

    return true
  end

end