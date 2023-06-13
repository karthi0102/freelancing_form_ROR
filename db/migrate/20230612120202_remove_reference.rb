class RemoveReference < ActiveRecord::Migration[7.0]
  def change
    remove_column :feedbacks, :to_id_id
    remove_column :feedbacks, :from_id_id
  end
end
