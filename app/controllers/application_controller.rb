class ApplicationController < ActionController::API
    #before auth function 
    before_action :authorized
#yoursecret change for your proj and want it as a ENV Var 
  def encode_token(payload)
    JWT.encode(payload, 'yourSecret')
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  #check if auth header, parse it for token and decode
  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, 'yourSecret', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end
  #if decoded token returnes true (user logged in) add the user data to the controller 
  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

 
  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end