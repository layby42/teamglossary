class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :glossary_terms, :sanscrit_gender, :sanskrit_gender
  end

  def down
    rename_column :glossary_terms, :sanskrit_gender, :sanscrit_gender
  end
end
