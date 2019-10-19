Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # ==> Devise routes

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

  # ==> Admin routes

  namespace :admin do
    resources :sellers, except: [:new, :create, :destroy] do
      get 'backstage', to: 'producer_dashboard#show', as: 'dashboard'
      resources :events, only: [:index, :new, :create]
      resource :finance, only: [:new, :create, :edit, :update]
      get '/remove_staff/:user_id', to: 'sellers#remove_staff', as: "remove_staff"
    end
    resources :events, except: [:index, :new, :create] do
      resources :offers, except: [:show, :edit, :new]
      resources :marketings, only: [:index]
      patch '/marketings/', to: 'marketings#update', as: 'marketing'
    end
    get '/check-in/:id', to: 'check_ins#show', as: 'check_in'
    resources :orders, only: [:index]
    resources :users, only: [:index]
    resources :ticket_tokens, only: [:show, :update]
    resources :transfers, only: [:create]
  end

  scope module: 'admin', path: '/', as: '' do
    get 'backoffice', to: 'dashboard#show', as: 'admin_dashboard'
    get '/send_received_email/:id', to: 'orders#send_received_email', as: 'send_received_email'
    get '/send_confirmed_email/:id', to: 'orders#send_confirmed_email', as: 'send_confirmed_email'
    get '/send_ticket_email/:id', to: 'orders#send_ticket_email', as: 'send_ticket_email'
    get '/send_legacy_email/:id', to: 'orders#send_legacy_email', as: 'send_legacy_email'
    get '/send_refunded_email/:id', to: 'orders#send_refunded_email', as: 'send_refunded_email'
    get '/send_denied_email/:id', to: 'orders#send_denied_email', as: 'send_denied_email'
  end

  match "/backoffice/split" => Split::Dashboard, anchor: false, via: [:get, :post, :delete], constraints: -> (request) do
    request.env['warden'].authenticated?
    request.env['warden'].authenticate!
    request.env['warden'].user.admin?
  end

  # ==> Producer admin routes

  namespace :producer_admin do
    resources :sellers, except: [:new, :create, :destroy]
    resources :events, only: [:index, :show] do
      resources :offers, only: [:index]
      resources :marketings, only: [:index]
      patch '/marketings/', to: 'marketings#update', as: 'marketing'
    end
    resources :transfers, only: [:create]
  end

  scope module: 'producer_admin', path: '/', as: '' do
    get 'backstage', to: 'dashboard#show', as: 'producer_admin_dashboard'
    get '/sellers/remove_staff/:user_id', to: 'sellers#remove_staff', as: "remove_staff"
    resources :events, except: [:index, :show] do
      resources :offers, only: [:create, :update, :destroy]
    end
    resource :finance, except: [:index, :destroy]
  end

  # ==> Producer routes

  namespace :producer do
    resources :events, only: [:index]
  end

  scope module: 'producer', path: '/', as: '' do
    get '/check-in/:id', to: 'check_ins#show', as: 'check_in'
    post 'validations/', to: 'validations#create', as: 'validations'
    get 'validations/:code', to: 'validations#new', as: 'new_validation'
  end

  # ==> Sellers routes
  resources :sellers, only: [:new, :create]

  # ==> Events routes

  resources :events, only: [:show]

  get '/ads/:id', to: 'ads#show', as: 'ads'
  get '/ads-ab/:id', to: 'ads#test_ab', as: 'ads_ab'

  get '/roupa-nova-montes-claros-1', to: redirect('/events/2')
  get '/roupa-nova-curvelo-ads-1', to: redirect('/events/1')
  get '/roupa-nova-curvelo-1', to: redirect('/events/1')

  # ==> Orders routes

  resources :orders, only: [:index, :new, :create]
  resources :orders, only: [:show], param: :number

  # ==> Ticket tokens routes

  resources :ticket_tokens, only: [:index, :show], path: 'tickets'
  get 'tickets_receipt/:number', to: 'tickets_receipt#show', as: 'tickets_receipt'

  # ==> Pages routes

  root to: 'pages#index'
  get 'index', to: 'pages#offline'
  get 'search', to: 'pages#search'
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'

  # ==> Chart routes

  namespace :charts do
    get 'sales-count/:seller_id', action: 'sales_count', as: 'sales_count'
    get 'sales-value/:seller_id', action: 'sales_value', as: 'sales_value'
    get 'sales-tickets/:seller_id', action: 'sales_tickets', as: 'sales_tickets'
    get 'all-sales-count'
    get 'all-sales-value'
    get 'all-sales-tickets'
    get 'report-tickets/:id', action: 'report_tickets', as: 'report-tickets'
    get 'report-count/:id', action: 'report_count', as: 'report-count'
    get 'report-value/:id', action: 'report_value', as: 'report_value'
  end

  # ==> Wirecard webhooks routes

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
