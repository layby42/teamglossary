class FaIconsProperNameType < ActiveRecord::Migration
  def up
    add_column :proper_name_types, :fa_icon, :string, limit: 100, null: false, default: 'fa-flag'
    execute(%q{UPDATE proper_name_types SET fa_icon = 'fa-tree' WHERE code = 'G';})
    execute(%q{UPDATE proper_name_types SET fa_icon = 'fa-image' WHERE code = 'I';})
    execute(%q{UPDATE proper_name_types SET fa_icon = 'fa-university' WHERE code = 'M';})
    execute(%q{UPDATE proper_name_types SET fa_icon = 'fa-user' WHERE code = 'P';})
    execute(%q{UPDATE proper_name_types SET fa_icon = 'fa-user' WHERE code = 'T';})
    execute(%q{UPDATE proper_name_types SET fa_icon = 'fa-site-map' WHERE code = 'D';})
    execute(%q{UPDATE proper_name_types SET fa_icon = 'fa-group' WHERE code = 'N';})
    execute(%q{UPDATE proper_name_types SET fa_icon = 'fa-university' WHERE code = 'C';})
    execute(%q{UPDATE proper_name_types SET fa_icon = 'fa-graduation-cap' WHERE code = 'H';})
  end

  def down
    remove_column :proper_name_types, :fa_icon
  end
end
