class CreateProjectStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :project_statuses do |t|
      t.datetime :start_date ,:end_date
      t.references :project ,null: false, foreign_key: true
      t.timestamps
    end
  end
end
