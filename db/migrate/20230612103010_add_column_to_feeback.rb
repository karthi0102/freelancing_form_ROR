class AddColumnToFeeback < ActiveRecord::Migration[7.0]
  def change
    add_reference :feedbacks, :authorable ,polymorphic: true
  end
end
