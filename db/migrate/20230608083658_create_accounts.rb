class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name, :email, :phone , :gender ,:password , :linkedin ,:github , :image ,:account_type
      t.timestamps
    end
  end
end
