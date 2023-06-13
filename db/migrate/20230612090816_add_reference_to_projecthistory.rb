class AddReferenceToProjecthistory < ActiveRecord::Migration[7.0]
  def change
    add_reference :project_statuses, :payment,null: true ,foreign_key: true
    add_column :payments, :paid_date ,:datetime
  end
end
