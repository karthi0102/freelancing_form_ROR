ActiveAdmin.register Applicant do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :status, :applicable_type, :applicable_id, :project_id
  #
  # or
  #

  permit_params do
    permitted = [:status, :applicable_type, :applicable_id, :project_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  #
  scope :all


  index do
    column "Applicant", :applicable
    column "Type", :applicable_type
    column :status
    column :project
    actions
  end

  filter :status ,as: :select ,collection: Applicant.pluck(:status).uniq
  filter :project,as: :select ,collection: Project.all
  filter :applicable_type

end
