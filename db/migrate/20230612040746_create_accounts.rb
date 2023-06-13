class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, :email ,:phone , :linkedin , :gender
      t.text :description
      t.references :accountable ,polymorphic: true
      t.timestamps
    end
  end
end



