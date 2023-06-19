ActiveAdmin.register ProjectMember do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :memberable_type, :memberable_id, :project_id, :feedback, :status
  #
  # or
  #
  scope :all
  permit_params do
    permitted = [:memberable_type, :memberable_id, :project_id, :feedback, :status]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  #
  index do
    column :project
    column "Member", :memberable
    column "Type", :memberable_type
    column "Feedback given", :feedback
    column :status
    actions
  end

  filter :project
  filter :feedback
  filter :status ,as: :select
end
