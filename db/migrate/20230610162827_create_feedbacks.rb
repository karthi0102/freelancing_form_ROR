class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.integer :rating
      t.string :comment
      t.references :account ,null: false, foreign_key: true
      t.timestamps
    end
  end
end
