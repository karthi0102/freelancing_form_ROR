class DropAccountTeamsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :accounts_teams
  end
end
