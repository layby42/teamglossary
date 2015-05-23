class Admin::ImportsController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:general_menu, :hopkins]
  before_action :find_tab, only: [:index, :new]

  def index
  end

  def new
    @import = Import.new
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
end
