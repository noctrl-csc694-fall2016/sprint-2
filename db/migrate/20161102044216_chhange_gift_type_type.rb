class ChhangeGiftTypeType < ActiveRecord::Migration[5.0]
  def change
    change_column :gifts, :gift_type, :integer
  end
end
