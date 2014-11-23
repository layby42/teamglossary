class UpdateProperNameTypeTable < ActiveRecord::Migration
  def up
    change_column :proper_name_types, :code, :string, limit: 3, null: false
    change_column :proper_name_types, :name, :string, limit: 100, null: false
    change_column :proper_name_types, :description, :string, limit: 2000
  end

  def down
  end
end
