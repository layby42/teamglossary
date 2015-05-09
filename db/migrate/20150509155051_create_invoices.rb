class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :user, null: false, index: true
      t.integer :month, null: false
      t.integer :year, null: false
      t.boolean :hours, null: false, default: true
      t.integer :amount, null: false, default: 0
      t.string :description
      t.datetime :sent_at
      t.string :status
      t.timestamps
    end

    add_foreign_key :invoices, :users
  end
end
