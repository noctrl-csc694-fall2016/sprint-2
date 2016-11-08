class UpdateGiftMoneyFields < ActiveRecord::Migration[5.0]
  def change
    # drop goal from activities table
    remove_column :gifts, :amount 
    remove_column :gifts, :pledge 
    # add amount as specified decimal field
    add_column :gifts, :amount, :decimal, :precision => 8, :scale => 2, default: 0.00
    add_column :gifts, :pledge, :decimal, :precision => 8, :scale => 2, default: 0.00
  end
end
