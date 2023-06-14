class AddHashTypeToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments ,:account_details, :jsonb, default: {}, null: false
  end
end
