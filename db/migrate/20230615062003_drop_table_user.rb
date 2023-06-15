class DropTableUser < ActiveRecord::Migration[7.0]
  def change
      drop_table :users
      remove_column :accounts , :password
  end
end
