class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :post_code
      t.string :state
      t.string :country

      t.timestamps
    end

    add_index :addresses, :user_id
    add_index :addresses, :country
    add_index :addresses, :city
  end
end
