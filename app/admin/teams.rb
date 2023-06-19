ActiveAdmin.register Team do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :admin_id
  #
  # or
  #
  permit_params do
    permitted = [:name, :description, :admin_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  #
  index do
    column :name
    column :description
    column "Admin",:admin
    column "Members",:freelancers
    column "Projects",:projects
    actions
  end
  scope :all
  filter :name
end
