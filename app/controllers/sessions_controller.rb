# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth(request.env['omniauth.auth'])
    if @user.new_record?
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
      found_user = User.where(username: params[:username]).first

      found_user = found_user.authenticate(params[:password]) if found_user
    end

    if found_user
      session[:user_id] = found_user.id
      flash[:notice] = 'You are now logged in.'
      redirect_to dashboard_path
    else
      flash.now[:alert] = 'Invalid username or password'
      render('signin/show')
    end
  end

  def register_create
    if params[:user].present?
      keys = %w[email first_name last_name uid provider]

      u = params[:user]

      keys.each do |k|
        params[k] = u[k] if u[k].present?
      end
    end

    if params_are_found?(params, %w[username password password_confirm email first_name last_name])
      if !(User.where(email: params[:email]).first || User.where(username: params[:username]).first) && params[:password].eql?(params[:password_confirm]) && password_valid(params[:password])
        u = User.new
        u.username = params[:username]
        u.password = params[:password]
        u.email = params[:email]
        u.first_name = params[:first_name]
        u.last_name = params[:last_name]
        u.points = 0
        u.is_admin = false

        u.uid = session[:uid]
        u.provider = session[:provider]

        u.save!

        session[:user_id] = u.id
        redirect_to(dashboard_path)
      else
        flash[:alert] = []

        unless User.where(username: params[:username]).empty?
          flash[:alert] << 'That username is taken, choose another username'
        end
        flash[:alert] << 'Please use another email' unless User.where(email: params[:email]).empty?
        flash[:alert] << 'The passwords do not match' if params[:password] != params[:password_confirm]

        flash_password_errors if !@password_errors.nil? && !@password_errors.empty?

        redirect_to(register_path)
      end
    else
      flash[:alert] = [] if flash[:alert].nil?
      flash[:alert] << 'Please enter all fields'
      redirect_to(register_path)
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.delete :user_token
    redirect_to signin_path
  end

  def params_are_found?(params, items)
    items.each do |n|
      return false unless params[n].present?
    end

    true
  end
end

def password_valid(password)
  password = password.split('')
  # check if uppercase is found
  @password_errors ||= []

  @password_errors << 'Password needs to be at least 8 characters' if password.length < 8

  # checks if there are capital letters
  has_cap = false
  password.each do |letter|
    if ('A'..'Z').include?(letter)
      has_cap = true
      break
    end
  end
  @password_errors << 'Password needs to have at least one capitalize letter' unless has_cap

  # checks if there are lowercase letters
  has_low = false
  password.each do |letter|
    if ('a'..'z').include?(letter)
      has_low = true
      break
    end
  end
  @password_errors << 'Password needs to have at least one lowercase letter' unless has_low

  # checks if there are numerical characters
  has_num = false
  password.each do |letter|
    if ('0'..'9').include?(letter)
      has_num = true
      break
    end
  end
  @password_errors << 'Password needs to have at least one number' unless has_num

  @password_errors.nil? || @password_errors.empty?
end

def flash_password_errors
  if @password_errors
    flash[:alert] ||= []

    @password_errors.each do |err|
      flash[:alert] << err
    end
  end
end
