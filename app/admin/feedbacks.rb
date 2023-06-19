ActiveAdmin.register Feedback do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :rating, :comment, :created_id, :recipient_id
  #
  # or
  #
  permit_params do
    permitted = [:rating, :comment, :created_id, :recipient_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  scope :all
  scope :rating_more_than_3
  scope :rating_less_than_3
  index do
    column :created
    column :recipient
    column :comment
    column :rating
    actions
  end

  filter :created
  filter :recipient

end
