Rails.application.routes.draw do
  get "client/registration" ,to:"client_registration#new"
  post "client/registration" ,to:"client_registration#create"
  get "freelancer/registration", to:"freelancer_registration#new"
  post "freelancer/registration", to:"freelancer_registration#create"
  get "profile/:id", to:"profile#show", as:'profile'
  get '/account/project/:id', to:"projects#mine", as:'my_projects'
  get '/project/apply/:id' ,to:"projects#add_account_applicant",as: 'apply_project_account'
  get '/project/apply/:project_id/:team_id', to:"projects#add_team_applicant", as: "apply_project_team"
  get "login", to:'login#new'
  post 'login', to:'login#create'
  post 'new_account_skill', to:'skills#create'
  get "project/accept/:applicant_type/:applicant_id:",to:'projects#accept', as:'accept_applicant'
  get "project/reject/:applicant_type/:applicant_id:",to:'projects#reject', as:'reject_applicant'
  resources :projects
  resources :teams
  root "landing#index"
end

