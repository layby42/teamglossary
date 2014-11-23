class Admin::LanguagesController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:new, :create, :update, :changes]
  before_action :find_language, only: [:show, :edit, :update, :changes]
  before_action :require_admin_or_language_manager, only: [:edit]
  before_action :find_tab, only: [:new, :create, :edit, :update]
  before_filter :require_xhr, :only => [:changes]

  def index
    @languages = Language.list_order.includes([:users])
  end

  def show
  end

  def new
    @language = Language.new
  end

  def create
    @language = Language.new(params_language)
    if @language.save
      flash_to notice: 'Changes saved!'
      redirect_to edit_admin_language_path(@language)
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @language.update_attributes(params_language)
      flash_to notice: 'Changes saved!'
      redirect_to action: :edit
    else
      render action: :edit
    end
  end

  def changes
    @changes = Change.for_item(@language).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_language
    @language = Language.find(params[:id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to admin_languages_path
  end

  def require_admin_or_language_manager
    unless current_user.admin? || current_user.manager?(@language.id)
      redirect_to admin_language_path(@language)
    end
  end

  def find_tab
    @tab = params[:tab].presence || 'details'
  end

  def params_language
    keys = [:iso_code, :name, :english_name, :notes, :encoding, :is_active]
    if current_user.admin?
      params.require(:language).permit(keys)
    else
      params.require(:language).permit(keys).slice(:name, :encoding)
    end
  end

  def require_xhr
    unless request.xhr?
      admin_language_path(@language)
    end
  end
end
