class AddAndRemoveColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :location, :string
    remove_column :freelancers, :location
  end
end
