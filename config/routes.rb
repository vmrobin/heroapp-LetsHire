LetsHire::Application.routes.draw do
  get "stub_dashboard/overview"
  resources :AssessmentsController

  # all V1 rest api (for mobile) should be below
  namespace :api do
    namespace :v1 do

      get 'test' => 'misc#test_connection'

      devise_scope :user do
        resources :sessions, :only => [:create, :destroy]
        post 'login' => 'sessions#create'
        delete 'logout' => 'sessions#destroy'
      end

      resources :interviews, :only => [:index, :show, :update]

      post 'photo/upload' => 'photos#upload_file'
      get 'photo/enum' => 'photos#list_files'
      get 'photo/download' => 'photos#get_file'

      match 'mappings' => 'misc#mappings'
    end
  end

  # Hacker for initialization
  match '/db_seed', to: 'application#db_seed'

  # all V1 rest api (for mobile) should be above

  root to: 'static_pages#home'
  match '/help', to: 'static_pages#help'
  match '/contact', to: 'static_pages#contact'



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

  get '/users/:id/disable', to: 'users#deactivate', as: :disable_user
  get '/users/:id/enable', to: 'users#reactivate', as: :enable_user
  devise_for :users
  match '/profile', to: 'profile#edit'
  match '/profile/update', to: 'profile#update'
  resources :users

  get '/departments/:id/user_select' => 'departments#user_select'
  resources :departments
  resources :openings
  resources :candidates do
    resources :interviews
    member do
      get 'resume'
      get 'new_opening'
      put 'create_opening'
    end
  end

  resources :opening_candidates do
    resource :assessments
  end

  resources :interviews

  get '/settings', to: 'settings#index'

  get '/addresses/subregion_options' => 'openings#subregion_options'
  get '/positions/opening_options' => 'openings#opening_options'
  get '/participants' => 'users#index_for_tokens'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
