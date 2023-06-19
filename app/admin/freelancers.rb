ActiveAdmin.register Freelancer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :github, :experience
  #
  # or
  #
  permit_params do
    permitted = [:github, :experience]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  scope :all
  scope :is_team_admin
  index do
    column "Account", :account
    column :github
    column :experience
    column "Team Admin",:team_admins
    column "Teams",:teams

    column "Projects",:projects
    actions
  end

  filter :skills
  filter :projects ,as: :select ,collection:Project.all
  filter :teams,as: :select ,collection:Team.all

end
