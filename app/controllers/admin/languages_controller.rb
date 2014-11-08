class Admin::LanguagesController < ApplicationController
  before_action :require_admin
  before_action :find_language, only: [:show, :edit, :update]
  before_action :find_tab, only: [:new, :create, :edit, :update]

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

  private

  def find_language
    @language = Language.find(params[:id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to admin_languages_path
  end

  def find_tab
    @tab = params[:tab].presence || 'details'
  end

  def params_language
    params.require(:language).permit(
      :iso_code,
      :name,
      :english_name,
      :notes)
  end
end
