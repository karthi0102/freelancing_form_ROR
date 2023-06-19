ActiveAdmin.register Client do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :company, :company_location
  #
  # or
  #
  scope :all
  scope :has_more_than_5_projects
  scope :has_less_than_5_projects
  permit_params do
    permitted = [:company, :company_location]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  index do
    column :company
    column :company_location
    column :account
    column :projects
    actions
  end

  filter :company ,as: :select ,collection: Client.pluck(:company).uniq
  filter :company_location ,as: :select ,collection: Client.pluck(:company_location).uniq
end
