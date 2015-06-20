class Admin::ImportsController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:general_menu, :hopkins]
  before_action :find_tab, only: [:index, :new]

  def index
  end

  def new
    @import = Import.new(
        encoding: 'UTF-8',
        language_id: Language.active.where(id: current_user.manager_language_ids).list_order.first.try(:id),
        glossary_type_id: GlossaryType.except_menu.list_order.first.id,
        user_id: current_user.id)
  end

  def create
    @tab = 'glossary'
    # check if user has access to language
    @import = Import.new(import_params.except(:file))
    @import.user = current_user

    unless GlossaryType.except_menu.where(id: @import.glossary_type_id).first
      raise 'Unsupported Glossary Type'
    end

    unless current_user.manager_language_ids.include?(@import.language_id)
      raise 'Sorry, insufficient access rights.'
    end

    unless import_params[:file].present?
      raise 'Import file must be specificed'
    end

    unless import_params[:file].content_type == 'text/csv'
      raise 'Only csv files accepted.'
    end

    @import.file = import_params[:file].original_filename

    raise 'Sorry, import implementation is in progress'
    # @import.data = ImportCSV.import!(import_params[:file], @import.encoding)
    # @import.save!

    # TODO: load import data into import table

  rescue Exception => ex
    p ex.backtrace
    flash_to error: ex.message
  ensure
    redirect_to new_admin_import_path
  end

  def general_menu
    ImportGeneralMenuHelper.import!
    flash_to notice: 'General Menu updated with data from CMS!'
  rescue Exception => ex
    p ex.backtrace
    flash_to error: ex.message
  ensure
    redirect_to admin_imports_path(tab: :general_menu)
  end

  def hopkins
    [:file_small, :file_large].each do |file_param|
      raise 'Import file can\'t be blank.' unless params[file_param].present?
      raise 'Only csv files accepted.' unless params[file_param].content_type == 'text/csv'
    end
    ImportHopkinsHelper.import!(params[:file_large], params[:file_small])
    flash_to notice: 'Jefrey Hopkins Terms imported!'
  rescue Exception => ex
    p ex.backtrace
    flash_to error: ex.message
  ensure
    redirect_to admin_imports_path(tab: :hopkins)
  end

  private

  def find_tab
    @tab = params[:tab].presence || 'glossary'
  end

  def import_params
    params.require(:import).permit(
      :glossary_type_id,
      :language_id,
      :file,
      :skip_rows,
      :encoding,
      :cols_separator)
  end

end
