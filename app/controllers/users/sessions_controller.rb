# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def authenticate
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split.last
      secret = Rails.application.credentials.devise_jwt_secret_key!

      begin
        JWT.decode(token, secret).first

        render json: {
          status: 200,
          message: "Authenticated.",
          token: token
        }, status: :ok

      rescue JWT::ExpiredSignature
        render json: {
          status: 400,
          message: "Signature has expired.",
          token: token
        }, status: :bad_request
      end
    else
      render json: {
        status: 422,
        message: "Authorization header not present."
      }, status: :unprocessable_entity
    end
  end

  private

  def respond_with(resource, _opt = {})
    @token = request.env["warden-jwt_auth.token"]
    headers["Authorization"] = @token

    render json: {
      status: {
        code: 200, message: "Logged in successfully.",
        token: @token,
        data: {
          user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      jwt_payload = JWT.decode(request.headers["Authorization"].split.last,
                               Rails.application.credentials.devise_jwt_secret_key!).first

      current_user = User.find(jwt_payload["sub"])
    end

    if current_user
      render json: {
        status: 200,
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
