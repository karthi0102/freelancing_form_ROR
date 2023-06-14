class AddColumnToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects , :available ,:boolean
    add_column :project_members, :status ,:string
  end
end
