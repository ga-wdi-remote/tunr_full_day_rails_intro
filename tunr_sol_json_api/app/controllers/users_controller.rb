class UsersController < ApplicationController
  before_action :authenticate, except: [:login, :create]
  before_action :authorize, except: [:login, :create]

  def create
    user = User.new(user_params)
    if user.save
      render json: {status: 200, message: "ok"}
    else
      render json: {status: 422, user: user.errors}
    end
  end

  def show
    user = current_user
    render json: {status: 200, user: user}
  end

  def login
    user = User.find_by(username: params[:user][:username])

    if user && user.authenticate(params[:user][:password])

      token = token(user.id, user.username)

      render json: { status: 201, token: token, user: user }
    else
      render json: { status: 401, message: "unauthorized" }
    end
  end

  private

  def token(id, username)
    JWT.encode(payload(id, username), ENV['JWT_SECRET'], 'HS256')
  end

  def payload(id, username)
    {
      exp: (Time.now + 5.minutes).to_i,
      iat: Time.now.to_i,
      iss: ENV['JWT_ISSUER'],
      user: {
        id: id,
        username: username
      }
    }
  end

  def user_params
    params.required(:user).permit(:username, :password)
  end

end
