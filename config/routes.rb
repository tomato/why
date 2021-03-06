Why::Application.routes.draw do
  devise_for :customers
  devise_for :supplier_users
  devise_for :admins

  resources  :supplier_users
  resources :rounds do 
    member do
      get :past
      get :future
    end
    resources  :deliveries do
      collection do
        post :create_all
      end
    end
  end
  resources :products do
    collection do 
      post :reorder
      get :cat
    end
  end
  resources :customers do
    member do
      get :invite
    end
    resources :orders do
      collection do
        get :confirm
        get :past
      end
    end
  end

  resources :suppliers do
    member do
      get :switch
      post :accept
      post :download
      post :labels
    end
  end

  scope :path => '/home', :controller => :home do 
    match '/index'	=> :index, :as => "home" 
    match '/index2'	=> :index2 
    match '/how' => :how, :as => "how"
    match '/about' => :about, :as => "about"
    match '/price' => :price, :as => "price"
    match '/contact' => :contact, :as => "contact"
    match '/blog' => :blog, :as => "blog"
    match '/guide' => :guide, :as => "guide"
  end

  match '/embed', :controller => :home, :action => :embed
  
  constraints(Subdomain) do  
    match '/', :to => redirect("/customers/sign_in") 
  end  
  
  root :to => "home#index"
  match 'test/' => 'java_script_tests#order'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
