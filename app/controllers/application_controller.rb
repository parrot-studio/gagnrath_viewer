class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :server_error
  end

  private

  def render_404
    render 'view/not_found', status: 404
  end

  def server_error
    render 'view/error', status: 500
  end

end
