class CreateHelpCategories < ActiveRecord::Migration
  def change
    create_table :help_categories do |t|
      t.string :title, null: false
      t.references :glossary_type
      t.integer :sorting, null: false, default: 0
      t.timestamps
    end

    add_foreign_key :help_categories, :glossary_types, dependent: :nullify
  end
end
