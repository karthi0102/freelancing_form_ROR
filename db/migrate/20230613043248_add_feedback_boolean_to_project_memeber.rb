class AddFeedbackBooleanToProjectMemeber < ActiveRecord::Migration[7.0]
  def change
    add_column :project_members, :feedback, :boolean
  end
end

