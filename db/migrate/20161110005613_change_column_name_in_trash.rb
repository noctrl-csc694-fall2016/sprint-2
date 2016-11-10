class ChangeColumnNameInTrash < ActiveRecord::Migration[5.0]
  def change
    rename_column :trashes, :category, :trash_type
  end
end
