class AddReferenceToSkill < ActiveRecord::Migration[7.0]
  def change
    add_reference :skills ,:freelancer ,null: false , foreign_key: true
  end
end
