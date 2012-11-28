class AddBrandNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :brand, :string
    add_index :users, :brand, unique: true
  end
end
