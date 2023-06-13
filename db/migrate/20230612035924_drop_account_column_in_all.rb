class DropAccountColumnInAll < ActiveRecord::Migration[7.0]
  def change
    remove_column :skills , :account_id
    remove_column :projects ,:account_id

  end
end
