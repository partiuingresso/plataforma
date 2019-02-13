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
  
  root to: 'home#index'
end
