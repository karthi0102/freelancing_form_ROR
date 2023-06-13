class CreateFreelancersTeamsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :freelancers ,:teams
  end
end
