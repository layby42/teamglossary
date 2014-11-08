module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_user

    helper_method :current_user_session
    helper_method :current_user
  end

  private

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      remember_back_location
      redirect_to login_path
    end
  end

  def require_no_user
    if current_user
      redirect_to '/'
    end
  end

  def require_admin
    unless current_user && current_user.admin?
      redirect_to root_path
    end
  end
end
