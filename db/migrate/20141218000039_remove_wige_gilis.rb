class RemoveWigeGilis < ActiveRecord::Migration
  def up
    remove_column :glossary_names, :wade_giles
    remove_column :import_glossary_names, :wade_giles
  end

  def down
    add_column :glossary_names, :wade_giles, :string
    add_column :import_glossary_names, :wade_giles, :string
  end
end
