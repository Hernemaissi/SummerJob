NetworkBusinessGame::Application.routes.draw do

 

  filter :locale


  resources :games
  resources :users
  resources :business_plans, only: [:edit, :update, :show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :groups, only: [:new, :create, :index, :show, :update]
  resources :companies, only: [:new, :create, :index, :show, :update, :edit]
  resources :needs, only: [:show]
  resources :rfps, only: [:show, :create, :new, :update]
  resources :bids, only: [:show, :create, :update]
  resources :contracts, only: [:show, :update, :destroy]
  resources :networks, only: [:new, :create, :show, :index]
  resources :operator_roles, only: [:index]
  resources :customer_facing_roles, only: [:index]
  resources :markets
  resources :effects
  resources :revisions, only: [:show, :update]
  resources :risks
  resources :company_reports, only: [:show]
  resources :network_reports, only: [:show, :index]
  resources :qualities
  resources :qualityvalues, only: [:show]
  resources :news
  resources :password_resets
  resources :parameters, only: [:edit, :update]
  resources :company_types
  resources :loans, only: [:new, :create, :show, :index]
  resources :contract_processes, only: [:update]
  
  root :to => 'static_pages#home'

  match '/dump/companies', to: 'companies#text_data', :as => :companies_dump
  match '/dump/users', to: 'users#text_data', :as => :users_dump
  match '/signup', to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/users/:id/tga', to: 'users#set_as_admin', :as => :set_admin
  match '/help', to: 'static_pages#help' 
  match '/about', to: 'static_pages#about'
  match '/implinks', to: 'static_pages#implinks'
  match '/busy', to: 'static_pages#busy', :as => :busy
  match '/progress', to: 'static_pages#progress'
  match '/results', to: 'static_pages#results', :as => :results
  match '/sort', to: 'groups#sort', :as => :sort_users
  match '/groups/:id/users', to: 'groups#show_users', :as => :show_users
  match '/groups/:id/users/:user_id', to: 'groups#add_member', :as => :add_member
  match '/groups/:id/remove/:user_id', to: 'groups#remove_member', :as => :remove_group_member
  match '/groups/:id/answers/:quality_id', to: 'groups#answers', :as => :show_answers
  match '/companies/:id/about/edit', to: 'companies#update_about_us', :as => :update_about
  match '/companies/:id/business', to: 'business_plans#show', :as => :show_plan
  match '/companies/:id/update_part/:part_id', to: 'business_plans#update_part'
  match '/companies/:id/business/submit', to: 'business_plans#update', :as => :submit_plan
  match '/companies/:id/business/verify', to: 'business_plans#verification', :as => :verify_plan
  match '/companies/:id/business/visibility', to: 'business_plans#toggle_visibility', :as => :visibility
  match '/companies/:id/init', to: 'companies#init', :as => :init
  match '/companies/:id/init/update', to: 'companies#update_init', :as => :init_update
  match '/companies/:id/mail', to: 'companies#mail', :as => :company_mail
  match '/companies/:id/results', to: 'companies#results', :as => :company_results
  match '/companies/init/stats', to: 'companies#get_stats'
  match '/companies/init/costs', to: 'companies#get_costs' 
  match '/send/:id', to:'rfps#new', :as => :send_rfp
  match '/companies/:id/bid', to:'bids#new', :as => :make_bid
  match '/networks/:id/companies', to: 'networks#show_companies', :as => :show_companies
  match '/networks/:id/companies/:company_id', to: 'networks#add_company', :as => :add_companies
  match '/networks/:id/remove/:company_id', to: 'networks#remove_company', :as => :remove_member
  match '/serviceroles/:service_type', to: 'service_roles#index', :as => :service_roles
  match '/search', to: 'layout_pages#index', :as => :search_header
  match '/search/users', to: 'users#search', :as => :search_users
  match '/search/group/:id/users', to: 'groups#search', :as => :search_group_users
#  match '/search/companies', to: 'companies#search', :as => :search_companies
  match '/search/auto/:field', to: 'users#autocomplete'
  match '/contracts/:id/negotiate/', to: 'contracts#decision', :as => :contract_decision
  match '/markets/:id/debug/', to: 'markets#debug', :as => :market_debug
  match '/markets/:id/graph', to: 'markets#graph', :as => :market_graph
  match '/markets/:id/changes', to: 'markets#changes'
  match '/markets/:id/parse', to: 'markets#parse', :as => :market_parse
  match '/networks/:id/results/', to: 'networks#results', :as => :network_results
  match '/networks/:id/news/', to: 'networks#news', :as => :network_news
  match '/networks/:id/relations/', to: 'networks#relations', :as => :network_relations
  match '/companies/:id/profile/', to: 'company_profiles#show', :as => :show_company_profile
  match '/companies/:id/profile/edit', to: 'company_profiles#edit', :as => :edit_company_profile
  match '/companies/:id/profile/update', to: 'company_profiles#update', :as => :update_company_profile
  match '/users/:id/assign', to: 'users#update_position', :as => :update_position
  match '/users/:id/register/:token', to: 'users#complete_registration', :as => :complete_registration
  match '/users/:id/groupregister/:token', to: 'users#complete_group_registration', :as => :complete_group_registration
  match '/users/:id/resend', to: 'users#resend_registration_mail', :as => :resend_registration
  match '/networks/quick/view', to: 'networks#quick_view', :as => :quick_view
  match '/qualities/addoption/:amount', to: 'qualities#add_option', :as => :add_option
  match '/qualities/addoption/:id/:amount', to: 'qualities#add_option', :as => :add_option_to_existing
  match '/games/:id/revert', to: 'games#revert', :as => :revert
  match '/games/:id/accept', to: 'games#accept', :as => :accept_game
  match '/games/:id/simulate', to: 'games#simulate', :as => :simulate
  match '/companies/event_update', to: 'events#read', :as => :read_events
  match '/companies/event_settings', to: 'events#settings', :as => :event_settings

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
