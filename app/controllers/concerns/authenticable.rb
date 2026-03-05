# frozen_string_literal: true

module Authenticable
  def current_user
    @current_user ||= User.find_by(id: decoded_token[:user_id]) if decoded_token
  end

  def authenticate_request!
    render json: { error: "Not authenticated" }, status: :unauthorized unless current_user
  end

  private

  def decoded_token
    header = request.headers["Authorization"]
    return nil unless header&.start_with?("Bearer ")

    token = header.split(" ").last
    JwtHandler.decode(token)
  end
end
