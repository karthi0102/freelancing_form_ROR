class RemoveColumnPayment < ActiveRecord::Migration[7.0]
  def change
    remove_column :payments ,:paid_date
  end
end
