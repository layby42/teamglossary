class ApplicationController < ActionController::Base
  include Authentication
  include Redirects
  include FlashHelpers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :base_language

  private

  def after_login_path(options = {})
    root_path
  end

  def base_language
    @base_language ||= Language.base.first
  end
end
