class ExtendProperNameTypesWithHaveDates < ActiveRecord::Migration
  def up
    add_column :proper_name_types, :has_dates, :boolean, null: false, default: false
    execute(%q{UPDATE proper_name_types SET has_dates = TRUE WHERE code IN ('P', 'D');})
  end

  def down
    remove_column :proper_name_types, :has_dates
  end
end
