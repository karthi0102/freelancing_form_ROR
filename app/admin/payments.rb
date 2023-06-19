ActiveAdmin.register Payment do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :amount, :status, :account_details
  #
  # or
  #
  scope :all
  permit_params do
    permitted = [:amount, :status, :account_details]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  index do
    column :account_details
    column :status
    column :amount
    actions
  end
  filter :status, as: :select
end
