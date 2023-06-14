class DropTableFeedbacl < ActiveRecord::Migration[7.0]
  def change
    drop_table :feedbacks
  end
end
