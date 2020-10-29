# frozen_string_literal: true

class MeController < ApplicationController
  before_action :authenticate

  def show
    u = current_user
  end
end
