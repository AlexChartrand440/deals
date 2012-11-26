class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :seller_id
      t.string :title
      t.decimal :price, precision: 8, scale:2
      t.text :description

      t.timestamps
    end

    add_index :products, :seller_id
    
  end
end
