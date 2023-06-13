class AddReferenceToFeeback < ActiveRecord::Migration[7.0]
  def change
    add_reference :feedbacks ,:to_id,null: false, foreign_key: {to_table: :accounts}
    add_reference :feedbacks ,:from_id,null: false ,foreign_key: {to_table: :accounts}

  end
end
