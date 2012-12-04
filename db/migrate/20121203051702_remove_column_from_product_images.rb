class RemoveColumnFromProductImages < ActiveRecord::Migration
  def up
    remove_index :product_images, [:product_id, :sort_order]
    remove_index :product_images, [:product_id, :default]
    remove_column :product_images, :sort_order
    remove_column :product_images, :default
  end

  def down
    add_column :product_images, :sort_order, :integer
    add_column :product_images, :default, :boolean, default: false

    add_index :product_images, [:product_id, :sort_order], unique: true
    add_index :product_images, [:product_id, :default] #to query the default image for the product
  end
end
