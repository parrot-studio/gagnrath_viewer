class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :server_error
  end

  private

  def title_navs
    @title_navs ||= []
    @title_navs
  end

  def add_navs(nav)
    return if nav.blank?
    title_navs << nav
  end

  def add_navs_for_date(date)
    ds = [date].flatten.reject(&:blank?)
    return if ds.empty?

    nav = if ds.size == 1
      divided_date(date)
    else
      "#{divided_date(ds.first)}-#{divided_date(ds.last)}"
    end
    add_navs(nav)
  end

  def render_404
    render 'view/not_found', status: 404
  end

  def server_error
    render 'view/error', status: 500
  end

end
