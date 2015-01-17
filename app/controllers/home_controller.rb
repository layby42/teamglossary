class HomeController < ApplicationController
  skip_before_action :require_user, except: [:download]
  before_action :find_language
  before_action :find_glossary
  before_action :find_query
  before_action :find_advanced
  before_action :find_columns
  before_action :find_translation_columns
  before_action :find_state

  PAGE_TITLE = 'Search'

  def index
    options = {
      columns: @columns,
      translation_columns: @translation_columns,
      search_private: @search_private,
      search_public: @search_public,
      search_proposed: @search_proposed
    }
    @data = Kaminari.paginate_array(@glossary_type.glossary_class.search(@language, @query, options)).page(params[:page])
  end

  def download
    options = {
      columns: @columns,
      translation_columns: @translation_columns,
      search_private: @search_private,
      search_public: @search_public,
      search_proposed: @search_proposed
    }
    data = @glossary_type.glossary_class.search(@language, @query, options)
    csv_data = ExportCsvHelper::prepare(@glossary_type.glossary_class, @language, data, {query: @query, col_sep: params[:col_sep]})
    file_name = @glossary_type.csv_file_name(@language)
    send_data csv_data,
            :filename => file_name,
            :content_type => 'text/csv;charset=iso-8859-1;header=present',
            :disposition => "attachment;filename=#{file_name}",
            :encoding => @language.encoding.to_s

  rescue Exception => ex
    flash_to error: ex.message
    redirect_to action: :index
  end

  private

  def find_language
    if params[:search].present?
      if current_user
        Setting.update_value!(current_user, :glossary_language, params[:search][:language_id])
      else
        session[:glossary_language] = params[:search][:language_id]
      end
      @language = Language.active.where(id: params[:search][:language_id]).first
    else
      language_id = current_user ? current_user.get_setting_value(:glossary_language) : session[:glossary_language]
      @language = Language.active.where(id: language_id).first if language_id
    end
    @language ||= Language.active.first
  end

  def find_glossary
    if params[:search].present?
      if current_user
        Setting.update_value!(current_user, :glossary_type, params[:search][:glossary_type_id])
      else
        session[:glossary_type] = params[:search][:glossary_type_id]
      end
      @glossary_type = GlossaryType.where(id: params[:search][:glossary_type_id]).first
    else
      glossary_type_id = current_user ? current_user.get_setting_value(:glossary_type) : session[:glossary_type]
      @glossary_type = GlossaryType.where(id: glossary_type_id).first if glossary_type_id
    end
    @glossary_type ||= GlossaryType.list_order.first
  end

  def find_query
    if params[:search].present?
      if current_user
        Setting.update_value!(current_user, :glossary_query, params[:search][:query])
      else
        session[:glossary_query] = params[:search][:query]
      end
      @query = params[:search][:query]
    else
      @query = current_user ? current_user.get_setting_value(:glossary_query) : session[:glossary_query]
    end
  end

  def find_advanced
    @advanced_search = false
    return unless current_user

    if params[:search].present?
      @advanced_search = (params[:search][:advanced].to_s == 'true')
      Setting.update_value!(current_user, :glossary_advanced, params[:search][:advanced])
    else
      @advanced_search = (current_user.get_setting_value(:glossary_advanced).to_s == 'true')
    end
  end

  def find_columns
    unless current_user
      @columns = @glossary_type.glossary_search_default_columns
      return
    end

    @columns = []

    if params[:search].present?
      if @advanced_search
        @columns = @glossary_type.glossary_search_columns && (params[:search][:columns] || [])
        Setting.update_value!(current_user, :glossary_columns, @columns.join(','))

        @columns = ['none'] if @columns.empty?
      else
        Setting.update_value!(current_user, :glossary_columns, nil)
        @columns = @glossary_type.glossary_search_columns
      end
    else
      if @advanced_search
        @columns = current_user.get_setting_value(:glossary_columns).to_s.split(',')
      end
    end
  end

  def find_translation_columns
    unless current_user
      @translation_columns = @glossary_type.glossary_search_default_translation_columns
      return
    end

    @translation_columns = []

    if params[:search].present?
      if @advanced_search && !@language.is_base_language?
        @translation_columns = @glossary_type.glossary_search_translation_columns && (params[:search][:translation_columns] || [])
        Setting.update_value!(current_user, :glossary_translation_columns, @translation_columns.join(','))

        @translation_columns = ['none'] if @translation_columns.empty?
      else
        Setting.update_value!(current_user, :glossary_translation_columns, nil)

        @translation_columns = @glossary_type.glossary_search_translation_columns
      end
    else
      if @advanced_search && !@language.is_base_language?
        @translation_columns = current_user.get_setting_value(:glossary_translation_columns).to_s.split(',')
      end
    end
  end

  def find_state
    @search_private = @search_public = @search_proposed = true
    return unless current_user
    return if @glossary_type.general_menu?

    if params[:search].present?
      if @advanced_search
        Setting.update_value!(current_user, :glossary_search_private, params[:search][:private])
        @search_private = (params[:search][:private].to_s == 'true')

        Setting.update_value!(current_user, :glossary_search_public, params[:search][:public])
        @search_public = (params[:search][:public].to_s == 'true')

        Setting.update_value!(current_user, :glossary_search_proposed, params[:search][:proposed])
        @search_proposed = (params[:search][:proposed].to_s == 'true')
      else
        Setting.update_value!(current_user, :glossary_search_private, true)
        Setting.update_value!(current_user, :glossary_search_public, true)
        Setting.update_value!(current_user, :glossary_search_proposed, true)
      end
    end
  end
end
