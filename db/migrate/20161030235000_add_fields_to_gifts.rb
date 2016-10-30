class AddFieldsToGifts < ActiveRecord::Migration[5.0]
  def change
    add_column :gifts, :pledge, :float
    add_column :gifts, :check_number, :integer
    add_column :gifts, :check_date, :datetime
    add_column :gifts, :anonymous, :boolean
    add_column :gifts, :memorial_note, :text
    add_column :gifts, :solicited_by, :string
    add_column :gifts, :gift_user, :string
    add_column :gifts, :gift_source, :string
  end
end
