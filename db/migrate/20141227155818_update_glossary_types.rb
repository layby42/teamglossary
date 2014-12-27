class UpdateGlossaryTypes < ActiveRecord::Migration
  def up
    add_column :glossary_types, :model_name, :string
    add_column :glossary_types, :sorting, :integer, null: false, default: 0

    execute(%q{UPDATE glossary_types SET model_name = 'GlossaryName', sorting=1 WHERE code = 'PPN';})
    execute(%q{UPDATE glossary_types SET model_name = 'GlossaryTerm', sorting=0 WHERE code = 'THT';})
    execute(%q{UPDATE glossary_types SET model_name = 'GlossaryTitle', sorting=2 WHERE code = 'TXT';})

    change_column :glossary_types, :model_name, :string, null: false
    execute(%q{
      INSERT INTO glossary_types(code, name, model_name, sorting)
      VALUES('GM', 'General menu', 'GeneralMenu', 3);
      })
  end

  def down
    remove_column :glossary_types, :model_name
    remove_column :glossary_types, :sorting
    execute(%q{DELETE FROM glossary_types WHERE code = 'GM';})
  end
end
