class CreateHelpArticles < ActiveRecord::Migration
  def change
    create_table :help_articles do |t|
      t.references :help_category, null:false
      t.string :title, null: false
      t.text :body
      t.datetime :published_at
      t.timestamps
    end
    add_foreign_key :help_articles, :help_categories
  end
end
