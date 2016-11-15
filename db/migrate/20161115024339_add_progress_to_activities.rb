class AddProgressToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :progress, :string
  end
end
