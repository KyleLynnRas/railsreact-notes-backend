class UsersController < ApplicationController
    #run this function before the route happens (check if user logged in)
    before_action :authorized, only: [:auto_login]
  
    # REGISTER - create user/ 
    def create
      @user = User.create(user_params)
      if @user.valid?
        token = encode_token({user_id: @user.id})
        render json: {user: @user, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
    # LOGGING IN -checks to see if user passed in correct 
    def login
      @user = User.find_by(username: params[:username])
  
      if @user && @user.authenticate(params[:password])
        token = encode_token({user_id: @user.id})
        render json: {user: @user, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
  #returns user - only hit this if authentication is working 
    def auto_login
      render json: @user
    end
  
    private
  #grab params from the route if the route has params 
    def user_params
      params.permit(:username, :password, :age)
    end
  
  end
  