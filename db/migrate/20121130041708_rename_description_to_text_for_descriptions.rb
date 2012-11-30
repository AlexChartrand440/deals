class RenameDescriptionToTextForDescriptions < ActiveRecord::Migration
  def up
    rename_column :product_descriptions, :description, :text
  end

  def down
    rename_column :product_descriptions, :text, :description
  end
end
