# frozen_string_literal: true

class SigninController < ApplicationController
  def show
    if user_signed_in?
      if user_is_admin?
        redirect_to(users_path)
      else
        redirect_to(dashboard_path)
      end
    end
  end
end
