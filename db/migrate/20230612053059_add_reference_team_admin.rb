class AddReferenceTeamAdmin < ActiveRecord::Migration[7.0]
  def change
    add_reference :team_admins ,:freelancer ,null: false ,foreign_key: true
  end
end
