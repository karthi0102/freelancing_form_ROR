Rails.application.routes.draw do


  get "client/registration" ,to:"client_registration#new"
  post "client/registration" ,to:"client_registration#create"
  get "freelancer/registration", to:"freelancer_registration#new"
  post "freelancer/registration", to:"freelancer_registration#create"
  get "profile/:id", to:"profile#show", as:'profile'
  get '/account/project/:id', to:"projects#mine", as:'my_projects'
  get '/project/apply/:id' ,to:"projects#add_applicant",as: 'apply_project'
  get "login", to:'login#new'
  post 'login', to:'login#create'
  post 'new_account_skill', to:'skills#create'
  get "project/:project_id/:applicant_id:",to:'projects#accept', as:'accept_project'
  resources :projects
  root "landing#index"
end
