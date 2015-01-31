module Help::ArticlesHelper
  def help_category_options(selected=nil)
    # ['General', nil]
    opts = [
      [
        'General',
        HelpCategory.general.list_order.collect{|hc| [hc.title, hc.id]}
      ]] +
      GlossaryType.list_order.includes([:help_categories]).inject([]) do |result, gt|
        result << [
          gt.name,
          gt.help_categories.sort{|x, y| x.sorting <=> y.sorting}.collect{|hc| [hc.title, hc.id]}
        ]
        result
      end

    grouped_options_for_select(opts, selected)
  end
end
