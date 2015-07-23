class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def current_user
    token = request.headers['Access-Token']
    if token
      @current_user ||= User.find_by(access_token: token)
    end
  end

  def authenticate_with_token!
    unless current_user
      render json: { message: "Access Token not found." },
        status: :unauthorized
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    logger.error ">>> User asked for invalid record: #{e.message}"
    render json: {
      message: "Couldn't find requested object",
      method: request.request_method,
      path: request.fullpath
    }, status: :not_found
  end
end
