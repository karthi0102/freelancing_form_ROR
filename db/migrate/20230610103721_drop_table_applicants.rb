class DropTableApplicants < ActiveRecord::Migration[7.0]
  def change
    drop_table :applicants
  end
end
