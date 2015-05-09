class AddPaidFlagUsers < ActiveRecord::Migration
  def change
    add_column :users, :paid, :boolean, null: false, default: false
  end
end
