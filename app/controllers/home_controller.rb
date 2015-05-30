class HomeController < ApplicationController
  skip_before_action :require_user, except: [:download]
  before_action :find_language
  before_action :find_glossary
  before_action :find_query
  before_action :find_method
  before_action :find_advanced
  before_action :find_columns
  before_action :find_translation_columns
  before_action :find_state
  before_action :find_extra

  PAGE_TITLE = 'Search'

  include FormatHelper

  def index
    options = {
      search_contains: (@search_method.presence == 'contains'),
      columns: @columns,
      translation_columns: @translation_columns,
      states: @search_states,
      extra: @search_extra
    }
    if @search_states.empty?
      @data = Kaminari.paginate_array([]).page(params[:page])
    else
      @data = Kaminari.paginate_array(@glossary_type.glossary_class.search(@language, @query, options)).page(params[:page])
    end
  end

  def download
    options = {
      columns: @columns,
      translation_columns: @translation_columns,
      states: @search_states
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
    elsif current_user.present?
      @query = current_user.get_setting_value(:glossary_query)
    else
      @query = session[:glossary_query]
    end
  end

  def find_method
    if params[:search].present?
      @search_method = (params[:search][:method].to_s.presence || 'start')
      @search_method = 'start' unless ['start', 'contains'].include?(@search_method)
      if current_user
        Setting.update_value!(current_user, :glossary_search_method, @search_method)
      else
        session[:glossary_search_method] = @search_method
      end
    elsif current_user.present?
      @search_method = current_user.get_setting_value(:glossary_search_method).to_s
    else
      @search_method = session[:glossary_search_method].to_s
    end

    @search_method = @search_method.to_s.presence || 'start'
  end

  def find_advanced
    if params[:search].present?
      @advanced_search = (params[:search][:advanced].to_s == 'true')
      if current_user
        Setting.update_value!(current_user, :glossary_advanced, params[:search][:advanced])
      else
        session[:glossary_advanced] = params[:search][:advanced]
      end
    elsif current_user.present?
      @advanced_search = (current_user.get_setting_value(:glossary_advanced).to_s == 'true')
    else
      @advanced_search = (session[:glossary_advanced].to_s == 'true')
    end
  end

  def find_columns
    @columns = []

    if params[:search].present?
      if @advanced_search
        @columns = @glossary_type.glossary_search_columns && (params[:search][:columns] || [])
        if current_user
          Setting.update_value!(current_user, :glossary_columns, @columns.join(','))
        else
          session[:glossary_columns] = @columns.join(',')
        end
        @columns = ['none'] if @columns.empty?
      else
        if current_user
          Setting.update_value!(current_user, :glossary_columns, nil)
        else
          session[:glossary_columns] = nil
        end
        @columns = @glossary_type.glossary_search_default_columns
      end
    elsif @advanced_search
      if current_user.present?
        @columns = current_user.get_setting_value(:glossary_columns).to_s.split(',')
      else
        @columns = session[:glossary_columns].to_s.split(',')
      end
    else
      @columns = @glossary_type.glossary_search_default_columns
    end
  end

  def find_translation_columns
    @translation_columns = []

    if params[:search].present?
      if @advanced_search && !@language.is_base_language?
        @translation_columns = @glossary_type.glossary_search_translation_columns && (params[:search][:translation_columns] || [])
        if current_user
          Setting.update_value!(current_user, :glossary_translation_columns, @translation_columns.join(','))
        else
          session[:glossary_translation_columns] = @translation_columns.join(',')
        end
        @translation_columns = ['none'] if @translation_columns.empty?
      else
        if current_user
          Setting.update_value!(current_user, :glossary_translation_columns, nil)
        else
          session[:glossary_translation_columns] = nil
        end
        @translation_columns = @glossary_type.glossary_search_default_translation_columns
      end
    elsif @advanced_search && !@language.is_base_language?
      if current_user.present?
        @translation_columns = current_user.get_setting_value(:glossary_translation_columns).to_s.split(',')
      else
        @translation_columns = session[:glossary_translation_columns].to_s.split(',')
      end
    else
      @translation_columns = @glossary_type.glossary_search_default_translation_columns
    end
  end

  def find_state
    @search_states = [:private, :public, :proposed].map(&:to_s)
    return if @glossary_type.general_menu?

    if params[:search].present?
      if @advanced_search
        @search_states = @search_states && (params[:search][:states] || [])
        if current_user
          Setting.update_value!(current_user, :glossary_search_states, @search_states.join(','))
        else
          session[:glossary_search_states] = @search_states.join(',')
        end
      else
        if current_user
          Setting.update_value!(current_user, :glossary_search_states, nil)
        else
          session[:glossary_search_states] = nil
        end
      end
    elsif @advanced_search
      if current_user
        @search_states = current_user.get_setting_value(:glossary_search_states).to_s.split(',')
      else
        @search_states = session[:glossary_search_states].to_s.split(',')
      end
    else
      @search_states = [:private, :public, :proposed].map(&:to_s)
    end
  end

  def find_extra
    @search_extra = []

    if params[:search].present?
      if @advanced_search && !@language.is_base_language?
        @search_extra = @glossary_type.glossary_search_extra & (params[:search][:extra] || [])
        if current_user
          Setting.update_value!(current_user, :glossary_search_extra, @search_extra.join(','))
        else
          session[:glossary_search_extra] = @search_extra.join(',')
        end
      else
        if current_user
          Setting.update_value!(current_user, :glossary_search_extra, nil)
        else
          session[:glossary_search_extra] = nil
        end
      end
    elsif @advanced_search && !@language.is_base_language?
      if current_user
        @search_extra = current_user.get_setting_value(:glossary_search_extra).to_s.split(',')
      else
        @search_extra = session[:glossary_search_extra].to_s.split(',')
      end
    end
  end

  def set_action_title
    @action_title = :root
  end
end
