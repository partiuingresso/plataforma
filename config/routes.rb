Rails.application.routes.draw do
  devise_for :users, controllers: {
  registrations: 'users/registrations',
  sessions: 'users/sessions',
  passwords: 'users/passwords',
  confirmations: 'users/confirmations',
  unlocks: 'users/unlocks'
  }
  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    get 'signup', to: 'users/registrations#new'
    delete 'signout', to: 'users/sessions#destroy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get '/backoffice', to: 'admin#admin'
  get '/backoffice/orders', to: 'admin#admin_orders'
  get '/backoffice/ticket/:id', to: 'admin#admin_download_ticket', as: 'admin_download_ticket'
  post '/backoffice/tickets/:id', to: 'ticket_tokens#update', as: 'admin_edit_ticket'
  get '/backoffice/users', to: 'admin#admin_users'
  get '/backstage', to: 'admin#producer_admin'
  get '/report/:id', to: 'admin#report', as: 'report'
  get '/check-in', to: 'admin#check_in'
  get '/manage_company/:company_id', to: 'admin#manage_company', as: "manage_company"

  namespace :charts do
    get 'sales-count'
    get 'sales-value'
    get 'report-count/:id', action: 'report_count', as: 'report-count'
    get 'report-value/:id', action: 'report_value', as: 'report_value'
  end

  resources :events
  get '/ads/:id', to: 'ads#show', as: 'ads'
  get '/ads-ab/:id', to: 'ads#test_ab', as: 'ads_ab'
  match "/backoffice/split" => Split::Dashboard, anchor: false, via: [:get, :post, :delete], constraints: -> (request) do
    request.env['warden'].authenticated?
    request.env['warden'].authenticate!
    request.env['warden'].user.admin?
  end
  resources :companies
  get '/companies/remove_staff/:user_id', to: 'companies#remove_staff', as: "remove_staff"

  resources :orders, only: [:index, :new, :create]
  get '/success/:number', to: 'orders#success', as: 'success'
  get '/denied/', to: 'orders#denied', as: 'denied'
  get '/send_received_email/:id', to: 'orders#send_received_email', as: 'send_received_email'
  get '/send_confirmed_email/:id', to: 'orders#send_confirmed_email', as: 'send_confirmed_email'
  get '/send_ticket_email/:id', to: 'orders#send_ticket_email', as: 'send_ticket_email'
  get '/send_legacy_email/:id', to: 'orders#send_legacy_email', as: 'send_legacy_email'
  get '/send_refunded_email/:id', to: 'orders#send_refunded_email', as: 'send_refunded_email'
  get '/send_denied_email/:id', to: 'orders#send_denied_email', as: 'send_denied_email'
  
  root to: 'pages#index'
  get 'index', to: 'pages#offline'
  get 'search', to: 'pages#search'
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'
  get 'tickets', to: 'ticket_tokens#index'
  get '/check-in/:id', to: 'check_ins#show'
  post 'validations/', to: 'validations#create', as: 'validations'
  get 'validations/:ticket_id', to: 'validations#new', as: 'new_validation'
  post 'tickets/validations', to: 'ticket_tokens#create_validation'
  get 'ticket/:id', to: 'ticket_tokens#show', as: 'ticket'

  resources :company_finances, only: [:new, :create, :edit, :update]
  resources :transfers, only: [:create]

  get '/roupa-nova-montes-claros-1', to: redirect('/events/2')
  get '/roupa-nova-curvelo-ads-1', to: redirect('/events/1')
  get '/roupa-nova-curvelo-1', to: redirect('/events/1')
  
  if Rails.env.development?
    post '/webhooks' => 'web_hooks#webhooks', as: :webhooks
  elsif Rails.env.staging?
    constraints subdomain: 'moip-stage', defaults: { format: :json } do
      post '/webhooks' => 'web_hooks#webhooks', as: :webhooks
    end
  else
    constraints subdomain: 'moip', defaults: { format: :json } do
      post '/webhooks' => 'web_hooks#webhooks', as: :webhooks
    end
  end
end
