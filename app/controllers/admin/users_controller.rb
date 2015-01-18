class Admin::UsersController < ApplicationController
  before_action :require_user
  before_action :require_admin, only: [:changes]
  before_action :require_admin_or_manager, only: [:index, :new, :create, :welcome]
  before_action :find_user, only: [:show, :edit, :update, :welcome, :changes]
  before_action :require_admin_or_manager_or_self, only: [:edit, :update]
  before_action :find_tab, only: [:new, :create, :edit, :update]
  before_filter :require_xhr, :only => [:changes]

  def index
    @users = User.list_order.includes([:languages])
  end

  def new
    @user = User.new(admin: false)
  end

  def create
    @user = User.new(params_user)
    @user.password = @user.password_confirmation = SecureRandom.hex(20)
    @user.login = SecureRandom.hex(10) ## TODO: remove column and related code
    if @user.save
      flash_to notice: 'Changes saved!'
      redirect_to edit_admin_user_path(@user)
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    unless current_user.admin? || (current_user.id == @user.id)
      if @user.login_count > 0
        flash_to error: 'Sorry, insufficient access rights'
        redirect_to admin_user_path(@user)
        return
      end
    end

    if @user.update_attributes(params_user)
      flash_to notice: 'Changes saved!'
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  def show
  end

  def welcome
    UserMailer.welcome_email(@user, password_reset_url: edit_password_reset_url(@user.perishable_token)).deliver
    flash_to notice: 'Welcome email have been sent to user!'
    redirect_to edit_admin_user_path(@user, tab: :team)
  end

  def changes
    @changes = Change.for_item(@user).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_user
    @user = User.find(params[:id])
  rescue
    flash_to error: 'Sorry, user not found'
    redirect_to admin_users_path
  end

  def require_admin_or_manager_or_self
    unless current_user.admin? || current_user.manager? || (current_user.id == @user.id)
      flash_to error: 'Sorry, insufficient access rights'
      redirect_to admin_user_path(@user)
    end
  end

  def find_tab
    @tab = params[:tab].presence || 'details'
  end

  def params_user
    keys = [:first_name, :last_name, :email, :about, :admin]
    if current_user.admin?
      params.require(:user).permit(keys)
    else
      params.require(:user).permit(keys).slice(:first_name, :last_name, :email, :about)
    end
  end

  def require_xhr
    unless request.xhr?
      redirect_to admin_user_path(@user)
    end
  end
end
