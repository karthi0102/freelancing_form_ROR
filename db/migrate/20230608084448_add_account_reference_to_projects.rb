class AddAccountReferenceToProjects < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :account, foreign_key: true
  end
end
