class CreateAccountTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :account_teams ,id: false do |t|
        t.belongs_to :account
        t.belongs_to :team
        t.timestamps
    end
  end
end

