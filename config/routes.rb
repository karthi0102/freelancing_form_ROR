Rails.application.routes.draw do
  use_doorkeeper
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :accounts, controllers: {
    sessions: 'accounts/sessions',
    password: 'accounts/passwords',
    registrations: "accounts/registrations",
    confirmations: "accounts/confirmations"
  }

  get 'bank/AccountDetails'
  get "client/registration" ,to:"client_registration#new"
  post "client/registration" ,to:"client_registration#create"

  get "freelancer/registration", to:"freelancer_registration#new"
  post "freelancer/registration", to:"freelancer_registration#create"

  get "profile/client/:id", to:"profile#client", as:'client_profile'
  get "profile/freelancer/:id", to:"profile#freelancer" ,as:"freelancer_profile"
  get 'projects/my', to:"projects#client", as:'my_projects'

  post 'project/apply/:id' ,to:"applicant#add_freelancer_applicant",as: 'apply_project_freelancer'
  post 'project/apply/:project_id/:team_id', to:"applicant#add_team_applicant", as: "apply_project_team"
  post "project/reject/:applicant_id:",to:'applicant#reject', as:'reject_applicant'

  get "login", to:'login#new'
  post 'login', to:'login#create'

  post 'skills', to:'skills#create'
  delete 'skills/:id' , to:"skills#destroy", as:"delete_skill"

  post 'teams/join/:team_id' , to:"teams#join" ,as:"join_team"
  post "teams/remove/:id/:freelancer_id", to:"teams#remove", as:"remove_freelancer"

  post "project/accept/:project_id/:applicant_id:",to:'project_member#accept', as:'accept_applicant'
  patch "project_member/completed/:project_id/:member_id" ,to:"project_member#member_completed",as:"project_member_complete_status"

  get "feedback/new/:to/:from/:member_id", to:"feedback#new" ,as:"new_feedback"
  post "feedback/new" ,to:"feedback#create"

  get "feedback/new/team/:to/:from/:member_id", to:"feedback#team",as:"new_team_feedback"
  post "feedback/team/new",to:"feedback#team_create"


  post "payment/new" , to:"payment#create" ,as:"payment"
  patch "project/set_available/:id", to:"projects#set_available",as:"set_available_status"

  get "account_details/:project_id/:member_id", to:"bank_account_details#new" ,as:"account_details"
  post "account_details/new", to:"bank_account_details#create" ,as:"new_account_details"

  get "payment/:project_id/:member_id",to:"payment#new",as:"payment_new"
  resources :projects
  resources :teams

  root "landing#index"

  namespace :api ,default: {format: :json} do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    devise_for :accounts, controllers: {
      sessions: 'accounts/sessions',
      password: 'accounts/passwords',
      registrations: "accounts/registrations",
      confirmations: "accounts/confirmations"
    }

    get 'bank/AccountDetails'
    # get "client/registration" ,to:"client_registration#new"
    # post "client/registration" ,to:"client_registration#create"

    # get "freelancer/registration", to:"freelancer_registration#new"
    # post "freelancer/registration", to:"freelancer_registration#create"

    get "profile/client/:id", to:"profile#client", as:'client_profile'
    get "profile/freelancer/:id", to:"profile#freelancer" ,as:"freelancer_profile"



    get 'projects/client', to:"projects#client"
    get "projects/freelancer",to:"projects#freelancer"
    get "projects/team/:id",to:"projects#team"
    get "projects/available",to:"projects#available_projects"


    get "freelancers/all",to:"account#freelancers"
    get "clients/all",to:"account#clients"


    get "projects/:id/applicants", to:"applicant#applicants"
    post 'project/apply/freelancer/:id' ,to:"applicant#add_freelancer_applicant",as: 'apply_project_freelancer'
    post 'project/apply/team/:project_id/:team_id', to:"applicant#add_team_applicant", as: "apply_project_team"

    patch "project/applicant/accept/:project_id/:applicant_id",to:'project_member#accept'
    patch "project/applicant/reject/:project_id/:applicant_id",to:'applicant#reject', as:'reject_applicant'

    get "freelancer/applications/:id",to:"applicant#freelancer_applications"
    get "team/applications/:id",to:"applicant#team_applications"

    get "project/:id/members",to:"project_member#show"
    patch "project_member/change_status/:id/:member_id",to:"project_member#completed"

    get "project/:id/status",to:'project_status#show'

    post 'skills', to:'skills#create'
    get "skills/:id" ,to:"skills#show"
    delete 'skills/:id' , to:"skills#destroy", as:"delete_skill"

    patch 'teams/join/:id' , to:"teams#join" ,as:"join_team"
    patch "teams/remove/:id/:freelancer_id", to:"teams#remove", as:"remove_freelancer"


    get "feedbacks",to:"feedback#show"
    post "feedback/freelancer/client/",to:"feedback#freelancer_to_client"
    post "feedback/team/client",to:"feedback#team_to_client"
    post "feedback/client/freelancer",to:"feedback#client_to_freelancer"
    post "feedback/client/team",to:"feedback#client_to_team"

    get "feedback/new/:to/:from/:member_id", to:"feedback#new" ,as:"new_feedback"
    post "feedback/new" ,to:"feedback#create"

    get "feedback/new/:to/:from/:member_id", to:"feedback#team",as:"new_team_feedback"
    post "feedback/team/new",to:"feedback#team_create"

    patch "project_member/payment/" , to:"payment#create" ,as:"payment"
    patch "project/set_available/:id", to:"projects#set_available",as:"set_available_status"

    get "project/:id/payment",to:"payment#show"
    get "account_details/:project_id/:member_id", to:"bank_account_details#new" ,as:"account_details"
    patch "account_details/new", to:"bank_account_details#create" ,as:"new_account_details"

    get "payment/:project_id/:member_id",to:"payment#new",as:"payment_new"
    resources :projects
    resources :teams

    root "landing#index"
  end
end

