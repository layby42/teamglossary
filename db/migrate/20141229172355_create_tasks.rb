class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.boolean :article, null: false, default: false
      t.boolean :audio, null: false, default: false
      t.boolean :video, null: false, default: false
      t.timestamps
    end

    add_index :tasks, :title, unique: true, using: :btree
  end
end
