class ChangeAttributeName < ActiveRecord::Migration[7.0]
  def change
    remove_column :feedbacks ,:from_id
    remove_column :feedbacks , :to_id
    add_column :feedbacks , :to ,:integer
    add_column :feedbacks , :from , :integer
  end
end
