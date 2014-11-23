class PasswordResetsController < ApplicationController
  skip_before_action :require_user, :only => [:new, :create, :edit, :update]
  before_action :find_user, :only => [:edit, :update]

  PAGE_TITLE = 'Reset password'
  layout 'login'

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(request_reset_params[:email])
    if @user
      UserMailer.password_reset_email(@user, password_reset_url: edit_password_reset_url(@user.perishable_token)).deliver
      flash_to notice: 'Password reset instructions have been emailed to you. Please check your email (including SPAM folder).'
      redirect_to login_path
    else
      flash_to error: 'Sorry, no user was found with that email address'
      redirect_to action: :new
    end
  end

  def edit
  end

  def update
    @user.password = set_password_params[:password]
    @user.password_confirmation = set_password_params[:password_confirmation]
    if @user.save_without_session_maintenance
      flash_to notice: 'Password successfully changed. Please login.'
      redirect_to login_path
    else
      render action: :edit
    end
  end

  private

  def request_reset_params
    params.require(:user).permit(:email)
  end

  def set_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by_perishable_token(params[:id])
    unless @user
      flash_to :notice => %q{
        We're sorry, but we could not locate your account.
        Please try copy and paste the URL
        from your email into your browser or restart the reset password process.
      }
      redirect_to action: :new
    end
  end
end
