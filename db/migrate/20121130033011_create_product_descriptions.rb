class CreateProductDescriptions < ActiveRecord::Migration
  def change
    create_table :product_descriptions do |t|
      t.integer :product_id
      t.text :description

      t.timestamps
    end
    add_index :product_descriptions, :product_id, unique: true
  end
end
