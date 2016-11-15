class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string  :email
      t.string  :password_digest
      t.string  :username
      t.integer :permission_level,  :default => 0
      t.date    :last_login
      t.timestamps
    end
  end
end
