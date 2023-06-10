class CreateProjectMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :project_members do |t|
      t.references :memberable, polymorphic:true
      t.references :project, null:false ,foreign_key: true
      t.timestamps
    end
  end
end

