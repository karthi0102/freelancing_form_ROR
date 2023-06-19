ActiveAdmin.register ProjectStatus do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :start_date, :end_date, :project_id, :status, :payment_id
  #
  # or
  #
  permit_params do
    permitted = [:start_date, :end_date, :project_id, :status, :payment_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  index do
    column :project
    column :start_date
    column :end_date
    column :status
    actions
  end
  scope :all
  filter :project
  filter :status ,as: :select

  

end
