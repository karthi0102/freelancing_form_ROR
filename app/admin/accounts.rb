ActiveAdmin.register Account do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :phone, :linkedin, :gender, :description, :accountable_type, :accountable_id, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
  #
  # or
  #
  permit_params do
    permitted = [:name, :email, :phone, :linkedin, :gender, :description, :accountable_type, :accountable_id, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  scope :all
  scope :rating_grater_than_3
  scope :rating_less_than_3
  index do
    column :name
    column :email
    column :phone
    column :linkedin
    column :description
    column :gender
    column "User Type", :accountable
    column "Recieved Feedbacks", :recipient_feedbacks
    column "Created Feedbacks", :creator_feedbacks
    actions
  end

  filter :email
  filter :phone
  filter :name
  filter :gender
  filter :accountable_type




end
