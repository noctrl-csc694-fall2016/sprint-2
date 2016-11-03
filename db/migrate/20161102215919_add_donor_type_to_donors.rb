class AddDonorTypeToDonors < ActiveRecord::Migration[5.0]
  def change
    add_column :donors, :donor_type, :integer
  end
end
