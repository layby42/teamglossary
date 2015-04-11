module Admin::ImportsHelper

  def imports_csv_column_separator_options(selected=nil)
    opts = [['semicolon (\';\')', ';'], ['comma (\',\')', ',']]
    options_for_select(opts, selected)
  end
end
