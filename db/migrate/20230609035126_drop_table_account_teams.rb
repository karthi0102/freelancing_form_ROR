class DropTableAccountTeams < ActiveRecord::Migration[7.0]
  def change
    drop_table :account_teams
  end
end
