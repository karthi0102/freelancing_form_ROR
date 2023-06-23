class DataTypeOfAmount < ActiveRecord::Migration[7.0]
  def change
    change_column :projects, :amount, :integer
  end
end
