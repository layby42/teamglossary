class HomeController < ApplicationController
  before_action :require_user
  before_action :find_language
  before_action :find_glossary

  PAGE_TITLE = 'Search'

  def index
    @query = params[:search].present? ? params[:search][:query] : nil
    @data = @glossary_type.glossary_class.simple_search(@language, @query.to_s.strip).page(params[:page])
  end

  private

  def find_language
    if params[:search].present?
      @language = current_user.languages.where(id: params[:search][:language_id]).first
      @language = current_user.languages.first unless @language
    else
      @language = current_user.languages.first
    end
  end

  def find_glossary
    if params[:search].present?
      @glossary_type = GlossaryType.where(id: params[:search][:glossary_type_id]).first
      @glossary_type = GlossaryType.list_order.first unless @glossary_type
    else
      @glossary_type = GlossaryType.list_order.first
    end
  end
end
