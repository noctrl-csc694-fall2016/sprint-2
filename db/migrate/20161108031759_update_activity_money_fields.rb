class UpdateActivityMoneyFields < ActiveRecord::Migration[5.0]
  def change
    # drop goal from activities table
    remove_column :activities, :goal 
    # add goal as specified decimal field
    add_column :activities, :goal, :decimal, :precision => 8, :scale => 2, default: 0.00
  end
end
