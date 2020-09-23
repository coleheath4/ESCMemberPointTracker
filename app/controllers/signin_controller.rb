class SigninController < ApplicationController
  def show
    if user_signed_in?
      redirect_to(me_path)
    end
  end
end
