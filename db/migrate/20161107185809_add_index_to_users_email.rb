class AddIndexToUsersEmail < ActiveRecord::Migration[5.0]
  #guarantees email uniqueness at the db level
  def change
    add_index :users, :email, unique: true
  end
end
