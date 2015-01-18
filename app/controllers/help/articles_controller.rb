class Help::ArticlesController < ApplicationController

  def index
    @glossary_type_id = (params[:help].presence || {})[:glossary_type_id]

    if current_user.admin?
      @categories = HelpCategory.where(glossary_type_id: @glossary_type_id).list_order.includes([:help_articles])
    else
      @categories = HelpCategory.where(glossary_type_id: @glossary_type_id).published.list_order.includes([:help_articles])
    end
  end
end
