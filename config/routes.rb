NetworkBusinessGame::Application.routes.draw do
  
  
  
  resources :users
  resources :business_plans, only: [:edit, :update, :show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :groups, only: [:new, :create, :index, :show]
  resources :companies, only: [:new, :create, :index, :show, :update]

  root :to => 'static_pages#home'
  
  match '/signup', to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/help', to: 'static_pages#help' 
  match '/about', to: 'static_pages#about'
  match '/groups/:id/users', to: 'groups#show_users', :as => :show_users
  match '/groups/:id/users/:user_id', to: 'groups#add_member', :as => :add_member
  match '/groups/:id/remove/:user_id', to: 'groups#remove_member', :as => :remove_member
  match '/companies/:id/business', to: 'business_plans#show', :as => :show_plan
  match '/companies/:id/update_part/:part_id', to: 'business_plans#update_part'
  match '/companies/:id/business/submit', to: 'business_plans#update', :as => :submit_plan
  match '/companies/:id/business/verify', to: 'business_plans#verification', :as => :verify_plan
  match '/companies/:id/business/visibility', to: 'business_plans#toggle_visibility', :as => :visibility
  match '/companies/:id/init', to: 'companies#init', :as => :init
  
  

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
