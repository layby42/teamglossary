class Admin::ImportsController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:general_menu, :hopkins]

  def index
  end

  def new
    @import = Import.new
  end

  def general_menu
    raise 'Import file can\'t be blank.' unless params[:file].present?
    ImportGeneralMenuHelper.import!(params[:file])
    flash_to notice: 'General menu imported!'
  rescue Exception => ex
    p ex.backtrace
    flash_to error: ex.message
  ensure
    redirect_to admin_imports_path
  end

  def hopkins
    [:file_small, :file_large].each do |file_param|
      raise 'Import file can\'t be blank.' unless params[file_param].present?
      raise 'Only csv files accepted.' unless params[file_param].content_type == 'text/csv'
    end

    ImportHopkinsHelper.import!(params[:file_large], params[:file_small])
    flash_to notice: 'General menu imported!'
  rescue Exception => ex
    p ex.backtrace
    flash_to error: ex.message
  ensure
    redirect_to admin_imports_path
  end
end
