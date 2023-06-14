class AddFreelancerReferenceToTeam < ActiveRecord::Migration[7.0]
  def change
    add_reference :teams, :admin, foreign_key: {to_table: :freelancers}
  end
end
