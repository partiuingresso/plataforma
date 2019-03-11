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

  resources :events
  resources :companies
  get '/companies/remove_staff/:user_id', to: 'companies#remove_staff', as: "remove_staff"

  resources :orders, only: [:index, :new, :create, :show]
  
  root to: 'pages#index'
  get 'search', to: 'pages#search'
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'
  get 'tickets', to: 'ticket_tokens#index'
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
