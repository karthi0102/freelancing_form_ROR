class CreateApplicants < ActiveRecord::Migration[7.0]
  def change
    create_table :applicants do |t|
      t.references :account, null: false ,foreign_key: true
      t.references :project, null: false ,foreign_key: true
      t.timestamps
    end
  end
end
