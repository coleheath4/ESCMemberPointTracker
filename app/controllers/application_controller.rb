
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def authenticate
  	redirect_to :signin unless user_signed_in?
  end

  def current_user
    if (!cookies[:user_token].blank? && session[:user_id].blank?)
      session[:user_id] = cookies[:user_token]
    end
    
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    
    cookies[:user_token] = { value: @current_user.id, expires: 1.months.from_now } if @current_user
    
    return @current_user
  end

  def user_signed_in?
  	!!current_user
  end

end