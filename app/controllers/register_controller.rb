# frozen_string_literal: true

class RegisterController < ApplicationController
  # default show
  def show
    @user ||= User.new

    keys = %i[first_name last_name email uid provider]

    keys.each do |k|
      if session.key?(k)
        @user[k] = session[k]
        puts @user[k]
      end
    end

    # if user is signed in, redirect to page about user
    redirect_to(dashboard_path) if user_signed_in?

    # if session.has_key?(:email)
    #   @user.email = session[:email]
    #   @user.first_name = session
    #   puts "Howdy!"
    #   puts @user.email
    # end
  end
end
