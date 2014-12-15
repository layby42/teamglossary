class HomeController < ApplicationController
  skip_before_action :require_user
  before_action :find_language
  before_action :find_glossary
  before_action :find_query

  PAGE_TITLE = 'Search'

  def index
    @data = Kaminari.paginate_array(@glossary_type.glossary_class.simple_search(@language, @query.to_s.strip.downcase)).page(params[:page])
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
    @language = Language.active.first unless @language
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
    @glossary_type = GlossaryType.list_order.first unless @glossary_type
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
end
