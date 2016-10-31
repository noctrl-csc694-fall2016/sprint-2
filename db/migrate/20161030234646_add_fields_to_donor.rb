class AddFieldsToDonor < ActiveRecord::Migration[5.0]
  def change
    add_column :donors, :title, :string
    add_column :donors, :nickname, :string
    add_column :donors, :country, :string
  end
end
