module Admin::TasksHelper
  def tasks_options_helper(item_type, selected=nil)
    opts = Task.where(item_type => true).collect{|t| [t.title, t.id]}
    options_for_select(opts, selected)
  end
end
