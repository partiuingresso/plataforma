Rails.application.routes.draw do
  devise_for :users, :controllers => { 
  :registrations => "users/registrations",
  :sessions => "users/sessions",
  :passwords => "users/passwords", 
  :confirmations => "users/confirmations",
  :unlocks => "users/unlocks"
  }
  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    get 'signup', to: 'users/registrations#new'
    delete 'signout', to: 'users/sessions#destroy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get '/backoffice', to: 'admin#admin'
  get '/backstage', to: 'admin#producer_admin'
  get '/report/:id', to: 'admin#report', as: 'report'
  get '/manage_company/:company_id', to: 'admin#manage_company', as: "manage_company"

  namespace :charts do
    get 'sales-count'
    get 'sales-value'
    get 'report-count/:id', action: 'report_count', as: 'report-count'
    get 'report-value/:id', action: 'report_value', as: 'report_value'
  end

  resources :events
  resources :companies
  get '/companies/remove_staff/:user_id', to: 'companies#remove_staff', as: "remove_staff"

  resources :orders, only: [:index, :new, :create, :show]
  
  root to: 'pages#index'
  get 'search', to: 'pages#search'
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'
  get 'tickets', to: 'ticket_tokens#index'
  get 'tickets/validations/new', to: 'ticket_tokens#new_validation'
  post 'tickets/validations', to: 'ticket_tokens#create_validation'
  get 'ticket/:id', to: 'ticket_tokens#show'

  resources :company_finances, only: [:new, :create, :edit, :update]
  resources :transfers, only: [:create]

  if Rails.env.development?
    post '/webhooks' => 'web_hooks#webhooks', as: :webhooks
  elsif Rails.env.production?
    constraints subdomain: 'moip', defaults: { format: :json } do
      post '/webhooks' => 'web_hooks#webhooks', as: :webhooks
    end
  end
end
