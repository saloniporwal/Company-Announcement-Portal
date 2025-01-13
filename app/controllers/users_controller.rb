class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request, only: [:show]

  # User Registration
  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'Welcome! You have successfully registered. We are excited to have you on board!' },
             status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # User Login
  def login
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, message: 'Login successful' }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # User Profile View Own Profile or Other User's Profile # users/:id
  def show
    begin
      @user = User.find(params[:id])
      render json: @user, serializer: UserSerializer, current_user_id: @current_user.id, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { message: "User not found" }, status: :not_found
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :dob, :address, :mobile_number,
                  :gender)
  end
end
