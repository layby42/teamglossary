module Admin::ImportsHelper

  def imports_csv_column_separator_options(selected=nil)
    opts = [['semicolon (\';\')', ';'], ['comma (\',\')', ',']]
    options_for_select(opts, selected)
  end


  def imports_csv_date_options(selected=nil)
    opts = [['dd.mm.yyyy', '%d.%m.%Y'],
                            ['dd-mm-yyyy', '%d-%m-%Y'],
                            ['dd/mm/yyyy', '%d/%m/%Y'],
                            ['dd/mm/yy', '%d/%m/%y'],
                            ['mm.dd.yyyy', '%m.%d.%Y'],
                            ['mm-dd-yyyy', '%m-%d-%Y'],
                            ['mm/dd/yyyy', '%m/%d/%Y'],
                            ['mm/dd/yy', '%m/%d/%y'],
                            ['yyyy.mm.dd', '%Y.%m.%d'],
                            ['yyyy-mm-dd', '%Y-%m-%d'],
                            ['yyyy/mm/dd', '%Y/%m/%d'],
                            ['yy/mm/dd', '%y/%m/%d']
                            ]
    options_for_select(opts, selected)
  end
end
