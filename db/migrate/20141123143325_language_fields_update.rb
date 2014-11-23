class LanguageFieldsUpdate < ActiveRecord::Migration
  def up
    change_column :languages, :iso_code, :string, limit: 10, null: false
    change_column :languages, :english_name, :string, limit: 100, null: false
    change_column :languages, :name, :string, limit: 100, null: false
    change_column :languages, :encoding, :string, limit: 15, null: false, default: 'UTF-8'
  end

  def down
  end
end
