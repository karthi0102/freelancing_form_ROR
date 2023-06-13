Rails.application.routes.draw do
  get "client/registration" ,to:"client_registration#new"
  post "client/registration" ,to:"client_registration#create"
  get "freelancer/registration", to:"freelancer_registration#new"
  post "freelancer/registration", to:"freelancer_registration#create"
  get "profile/client/:id", to:"profile#client", as:'client_profile'
  get "profile/freelancer/:id", to:"profile#freelancer" ,as:"freelancer_profile"
  get 'account/project/:id', to:"projects#mine", as:'my_projects'
  post 'project/apply/:id' ,to:"projects#add_freelancer_applicant",as: 'apply_project_freelancer'
  post 'project/apply/:project_id/:team_id', to:"projects#add_team_applicant", as: "apply_project_team"
  get "login", to:'login#new'
  post 'login', to:'login#create'
  post 'new_freelancer_skill', to:'skills#create'
  post 'team/join/:team_id' , to:"teams#join" ,as:"join_team"
  post "project/accept/:applicant_id:",to:'projects#accept', as:'accept_applicant'
  post "project/reject/:applicant_id:",to:'projects#reject', as:'reject_applicant'
  post "team/reject/:team_id/:freelancer_id", to:"teams#remove", as:"remove_freelancer"
  patch "project/completed/:id" ,to:"projects#completed",as:"project_complete_status"
  get "feedback/new/:to/:to_type/:from/:from_type", to:"feedback#new" ,as:"new_feedback"
  post "feedback/new" ,to:"feedback#create"
  get "feedback/new/:to/:from", to:"feedback#team",as:"new_team_feedback"
  post "feedback/team/new",to:"feedback#team_create"
  get "/payment/new/:id" , to:"payment#new", as:"payment_new"
  post "payment/new" , to:"payment#create" ,as:"payment"
  resources :projects
  resources :teams

  root "landing#index"
end


