class DropTableTeamAdmin < ActiveRecord::Migration[7.0]
  def change
    drop_table :team_admins
  end
end
