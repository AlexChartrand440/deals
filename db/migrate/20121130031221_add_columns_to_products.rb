class AddColumnsToProducts < ActiveRecord::Migration
  def up
    remove_column :products, :description
    add_column :products, :status, :boolean, default: true
    add_column :products, :quantity, :integer, default: 0 #auto summation of quantities for each option on save
    add_column :products, :discounted_price, :decimal, :precision => 8, :scale => 2
    add_column :products, :discounted_percentage_off, :integer #auto calculate on save
    add_column :products, :discount_start_date, :date
    add_column :products, :discount_end_date, :date
    add_column :products, :discount_days_left, :integer #cron job, auto calculate
    add_column :products, :for_sale, :boolean, default: false #cron job, if start date == today, change to true, check also for status to be true

    add_index :products, :status
    add_index :products, :quantity
    add_index :products, :for_sale
    add_index :products, [:for_sale, :quantity]

    #use for cron job and for frontend to highlight new items! new is defined as less than 2 days old
    add_index :products, :discount_start_date
    add_index :products, :discount_end_date 
  end

  def down
    remove_index :products, :status
    remove_index :products, :quantity
    remove_index :products, :for_sale
    remove_index :products, [:for_sale, :quantity]
    remove_index :products, :discount_start_date
    remove_index :products, :discount_end_date 
    
    add_column :products, :description, :text
    remove_column :products, :status
    remove_column :products, :quantity
    remove_column :products, :discounted_price
    remove_column :products, :discounted_percentage_off
    remove_column :products, :discount_start_date
    remove_column :products, :discount_end_date
    remove_column :products, :discount_days_left
    remove_column :products, :for_sale
  end

end
