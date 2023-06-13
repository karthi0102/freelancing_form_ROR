class DropAccountTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :team_admins ,:account_id
    remove_column :feedbacks ,:account_id
    drop_table :accounts
  end
end
