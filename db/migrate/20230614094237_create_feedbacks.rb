class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.integer :rating
      t.text :comment
      t.references :created ,foreign_key:{to_table: :accounts}
      t.references :recipient ,foreign_key:{to_table: :accounts}
      t.timestamps
    end
  end
end
