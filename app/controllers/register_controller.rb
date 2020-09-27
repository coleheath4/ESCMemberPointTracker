class RegisterController < ApplicationController
  # default show
  def show
    # if user is signed in, redirect to page about user
    if user_signed_in?
      redirect_to(dashboard_path)
    end

    @user ||= User.new

    keys = [:first_name, :last_name, :email, :uid, :provider]

    keys.each do |k|
      if session.has_key?(k)
        @user[k] = session[k]
        puts @user[k]
      end
    end
    
    # if session.has_key?(:email)
    #   @user.email = session[:email]
    #   @user.first_name = session
    #   puts "Howdy!"
    #   puts @user.email
    # end
  end
end
