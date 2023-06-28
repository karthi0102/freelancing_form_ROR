class AddLocationToFreelancer < ActiveRecord::Migration[7.0]
  def change
    add_column :freelancers, :location, :string
  end
end
