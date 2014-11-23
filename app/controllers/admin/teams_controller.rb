class Admin::TeamsController < ApplicationController
  before_action :require_admin_or_manager
  before_action :find_language
  before_action :find_user
  before_action :find_language_user, only: [:destroy]
  before_filter :require_xhr, :only => [:new, :edit]

  layout false

  def new
    @language_user = LanguageUser.new(
      language_id: params[:language_id],
      user_id: params[:user_id],
      role: params[:role]
      )
  end

  def create
    if @language.present?
      @language_user = @language.language_users.where(user_id: language_user_params[:user_id]).first
      @language_user = @language.language_users.new(language_user_params) unless @language_user
      @language_user.language = @language
      @language_user.role = language_user_params[:role]
    elsif @user.present?
      @language_user = @user.language_users.where(language_id: language_user_params[:language_id]).first
      @language_user = @user.language_users.new(language_user_params) unless @language_user
      @language_user.user = @user
      @language_user.role = language_user_params[:role]
    end

    if current_user.admin? || current_user.manager?(@language_user.language_id)
      if @language_user.save
        flash_to notice: 'Changes saved!'
      else
        flash_to error: @language_user.errors.full_messages.first
      end
    else
      flash_to error: 'Sorry, your access level does not permit this operation.'
    end

    do_proper_redirect
  end

  def destroy
    if current_user.admin? || current_user.manager?(@language_user.language_id)
      @language_user.destroy
    else
      flash_to error: 'Sorry, your access level does not permit this operation.'
    end
    do_proper_redirect
  end

  private

  def find_language
    return unless params[:language_id].present?
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to admin_languages_path
  end

  def find_user
    return unless params[:user_id].present?
    @user = User.find(params[:user_id])
  rescue
    flash_to error: 'Sorry, user not found'
    redirect_to admin_users_path
  end

  def find_language_user
    if @language.present?
      @language_user = @language.language_users.find(params[:id])
    elsif @user.present?
      @language_user = @user.language_users.find(params[:id])
    else
      @language_user = LanguageUser.find(params[:id])
    end
  rescue
    flash_to error: 'Sorry, user permission not found'
    do_proper_redirect
  end

  def language_user_params
    params.require(:language_user).permit(
      :language_id,
      :user_id,
      :role)
  end

  def require_xhr
    unless request.xhr?
      do_proper_redirect
    end
  end

  def do_proper_redirect
    if @language.present?
      redirect_to edit_admin_language_path(@language, tab: :team)
    elsif @user.present?
      redirect_to edit_admin_user_path(@user, tab: :team)
    else
      redirect_to admin_settings_path
    end
  end
end
