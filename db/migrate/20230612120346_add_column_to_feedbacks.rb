class AddColumnToFeedbacks < ActiveRecord::Migration[7.0]
  def change
    add_column :feedbacks, :from_id, :integer
    add_column :feedbacks, :to_id, :integer
  end
end
