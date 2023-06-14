class MofifyColumnPayment < ActiveRecord::Migration[7.0]
  def change
    remove_column :payments ,:account_details
    add_column :payments ,:account_details, :jsonb, default: {values:[]}, null: false
  end
end

