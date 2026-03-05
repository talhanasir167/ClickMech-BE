# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[login register]

  def register
    user = User.new(user_params)
    if user.save
      token = JwtHandler.encode(user_id: user.id)
      render json: { user: user_response(user), token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email]&.downcase)
    if user&.authenticate(params[:password])
      token = JwtHandler.encode(user_id: user.id)
      render json: { user: user_response(user), token: token }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def me
    render json: { user: user_response(current_user) }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_response(user)
    { id: user.id, email: user.email }
  end
end
