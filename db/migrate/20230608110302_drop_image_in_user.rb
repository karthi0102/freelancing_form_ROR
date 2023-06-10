class DropImageInUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts , :image
  end
end
