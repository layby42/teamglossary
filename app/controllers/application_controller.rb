class ApplicationController < ActionController::Base
  include Authentication
  include Redirects
  include FlashHelpers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_ssl

  helper_method :base_language
  helper_method :team_ids
  helper_method :manager_or_editor_language_ids
  helper_method :manager_language_ids

  private

  def after_login_path(options = {})
    root_path
  end

  def base_language
    @base_language ||= Language.base_language
  end

  def team_ids
    if current_user
      current_user.team_ids
    else
      []
    end
  end

  def manager_or_editor_language_ids
    if current_user
      current_user.manager_or_editor_language_ids
    else
      []
    end
  end

  def manager_language_ids
    if current_user
      current_user.manager_language_ids
    else
      []
    end
  end

  def require_ssl
    if Rails.env.production? || Rails.env.staging?
      redirect_to :protocol => 'https://' unless request.ssl?
    end
  end
end
