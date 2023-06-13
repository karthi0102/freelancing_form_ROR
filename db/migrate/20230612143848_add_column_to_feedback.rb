class AddColumnToFeedback < ActiveRecord::Migration[7.0]
  def change
    add_column :feedbacks, :from_type, :string
    add_column :feedbacks, :to_type, :string
  end
end
