class CreateAccountsTeamsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :accounts ,:teams
  end
end
