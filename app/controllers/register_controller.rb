class RegisterController < ApplicationController
  # default show
  def show
    # if user is signed in, redirect to page about user
    if user_signed_in?
      redirect_to(me_path)
    end
  end
end
