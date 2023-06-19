ActiveAdmin.register Project do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :amount, :description, :client_id, :available
  #
  # or
  #
  permit_params do
    permitted = [:name, :amount, :description, :client_id, :available]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  scope :available
  scope :unavailable
  index do
    column :name
    column :amount
    column :description
    column "Owner", :client
    column :available
    column :applicants
    column :project_members
    column :project_status
    column :payment
    actions
  end

  filter :name
  filter :amount
end
