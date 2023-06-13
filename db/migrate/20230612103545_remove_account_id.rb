class RemoveAccountId < ActiveRecord::Migration[7.0]
  def change
    remove_column :feedbacks ,:account_id
  end
end
