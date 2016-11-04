class ChhangeGiftTypeType < ActiveRecord::Migration[5.0]
  def change
    # drop gift_type from gifts table
    remove_column :gifts, :gift_type 
    # add gift_type as integer to gifts table
    add_column :gifts, :gift_type, :integer, default: 0
  end
end
