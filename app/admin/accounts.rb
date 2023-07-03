ActiveAdmin.register Account do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  #  permit_params :name, :email, :phone, :linkedin, :gender, :description,
  # or
  #
  actions :index,:show,:destroy
  permit_params do
    permitted = [:name, :email, :phone, :linkedin, :gender, :description, :location]
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
    column :location
    column "User Type", :accountable
    column "Recieved Feedbacks", :recipient_feedbacks
    column "Created Feedbacks", :creator_feedbacks
    actions
  end

  filter :email
  filter :phone
  filter :name
  filter :gender
  filter :location
  filter :accountable_type

end
