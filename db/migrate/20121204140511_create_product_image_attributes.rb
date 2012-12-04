class CreateProductImageAttributes < ActiveRecord::Migration
  def change
    create_table :product_image_attributes do |t|
      t.integer :product_id
      t.integer :product_image_id
      t.integer :sort_order
      t.boolean :default, default: false

      t.timestamps
    end
    
    add_index :product_image_attributes, :product_id
    add_index :product_image_attributes, :product_image_id
    add_index :product_image_attributes, [:product_id, :product_image_id], unique: true, name: "index_on_product_id_and_product_image_id"
    add_index :product_image_attributes, [:product_id, :sort_order], unique: true, name: "index_on_product_id_and_sort_order" #to impose uniqueness on sort order of images for given product
    add_index :product_image_attributes, [:product_id, :default], name: "index_on_product_id_and_default" #to query the default image for the product.. can't impose uniqueness because one product can have many non-default
  end
end
