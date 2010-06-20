ActionController::Routing::Routes.draw do |map|
  map.devise_for :customers
  map.devise_for :supplier_users
  map.devise_for :admins

  map.resources :suppliers, :deliveries, :products, :supplier_users
  map.resources :rounds, :member => { :past => :get,
                                      :future => :get}
  map.resources :customers, :has_many => :orders, 
    :member => { :invite => :get, :resend => :get}

  map.home 'home/', :controller => 'home'
  map.root :controller => "home"
  map.test 'test/', :controller => 'JavaScriptTests', :action => 'order'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
