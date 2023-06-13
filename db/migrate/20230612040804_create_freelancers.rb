class CreateFreelancers < ActiveRecord::Migration[7.0]
  def change
    create_table :freelancers do |t|
      t.string :github
      t.text :experience
      t.timestamps
    end
  end
end
