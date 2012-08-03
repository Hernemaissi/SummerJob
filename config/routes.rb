NetworkBusinessGame::Application.routes.draw do

 



  resources :games
  resources :users
  resources :business_plans, only: [:edit, :update, :show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :groups, only: [:new, :create, :index, :show]
  resources :companies, only: [:new, :create, :index, :show, :update, :edit]
  resources :needs, only: [:show]
  resources :rfps, only: [:show, :create, :new]
  resources :bids, only: [:show, :create, :update]
  resources :contracts, only: [:show, :update]
  resources :networks, only: [:new, :create, :show, :index]
  resources :operator_roles, only: [:index, :edit, :update]
  resources :customer_facing_roles, only: [:index, :edit, :update]
  resources :service_roles, only: [:edit, :update]
  resources :markets
  resources :effects

  root :to => 'static_pages#home'
  
  match '/signup', to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/help', to: 'static_pages#help' 
  match '/about', to: 'static_pages#about'
  match '/implinks', to: 'static_pages#implinks'
  match '/busy', to: 'static_pages#busy', :as => :busy
  match '/progress', to: 'static_pages#progress'
  match '/results', to: 'static_pages#results', :as => :results
  match '/groups/:id/users', to: 'groups#show_users', :as => :show_users
  match '/groups/:id/users/:user_id', to: 'groups#add_member', :as => :add_member
  match '/groups/:id/remove/:user_id', to: 'groups#remove_member', :as => :remove_member
  match '/companies/:id/about/edit', to: 'companies#update_about_us', :as => :update_about
  match '/companies/:id/business', to: 'business_plans#show', :as => :show_plan
  match '/companies/:id/update_part/:part_id', to: 'business_plans#update_part'
  match '/companies/:id/business/submit', to: 'business_plans#update', :as => :submit_plan
  match '/companies/:id/business/verify', to: 'business_plans#verification', :as => :verify_plan
  match '/companies/:id/business/visibility', to: 'business_plans#toggle_visibility', :as => :visibility
  match '/companies/:id/init', to: 'companies#init', :as => :init
  match '/companies/:id/mail', to: 'companies#mail', :as => :company_mail
  match '/companies/init/stats', to: 'companies#get_stats'
  match '/companies/:id/need/:other_id', to: 'needs#create', :as => :add_need
  match '/companies/:id/rneed/:other_id', to: 'needs#destroy', :as => :remove_need
  match '/send/:id', to:'rfps#new', :as => :send_rfp
  match '/rfps/:id/bid', to:'bids#new', :as => :make_bid
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
  match '/networks/:id/results/', to: 'networks#results', :as => :network_results
  match '/companies/:id/profile/', to: 'company_profiles#show', :as => :show_company_profile
  match '/companies/:id/profile/edit', to: 'company_profiles#edit', :as => :edit_company_profile
  match '/companies/:id/profile/update', to: 'company_profiles#update', :as => :update_company_profile
  match '/users/:id/assign', to: 'users#update_position', :as => :update_position

  

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
