class Api::V1::UsersController < ApplicationController
    # skip controller auth
    skip_before_action :verify_authenticity_token

    # GET /users
    def index 
        @users = User.sorted
        render json: @users
    end

    # GET /user/:id
    def show
        @user = User.find(params[:id])
        render json: @user
    end

    # POST /users
    # def create 
    #     @user = User.new(user_params)
    #     if @user.save
    #         render json: @user
    #     else
    #         render error: { error: 'Unable to create User.' }, status: 400
    #     end
    # end

    # PUT /users/:id
    def update 
        @user = User.find(params[:id])
        if @user
            @user.update(user_params)
            render json: { message: 'User successfully updated.' }, status: 200
        else 
            render error: { error: 'Unable to update user.' }, status: 400
        end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :is_admin, :username, :email, :points)
    end
end
