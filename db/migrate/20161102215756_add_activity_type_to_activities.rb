class AddActivityTypeToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :activity_type, :integer
  end
end
