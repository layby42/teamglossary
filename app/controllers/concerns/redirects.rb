module Redirects
  extend ActiveSupport::Concern

  included do
    helper_method :back_url_or_default
    helper_method :next_url_or_default
  end

  # Back navigation helpers

  def remember_back_location
    session[:back_location] = request.url
  end

  def back_url_or_default(default)
    session[:back_location].presence || default
  end

  def redirect_back_or_default(default)
    redirect_to(session[:back_location] || default)
    session.delete(:back_location)
  end

  # Next (to the referer) navigation helpers

  def remember_next_location
    session[:next_location] = request.referer
  end

  def next_url_or_default(default)
    session[:next_location].presence || default
  end

  def redirect_next_or_default(default)
    redirect_to(session[:next_location].presence || default)
    session.delete(:next_location)
  end

  # SSL helpers

  def require_ssl
    redirect_to :protocol => 'https' unless request.ssl?
  end
end
