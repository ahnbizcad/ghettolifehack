Rails.application.routes.draw do
  get 'pages/about',    as: "about"
  get 'pages/contact',  as: "contact"
  get 'pages/feedback', as: "feedback"

  root 'hacks#index'
  #get '*path' => 'application#index'

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end
  
  resources :comments, only: [:create, :destroy] #Polymorphic 

  resources :hacks, concerns: :paginatable do
    post "favorite", on: :member    
  end
  get "tag/:tag", to: "hacks#index", as: :tag

  resources :users, except: [:new, :create, :delete]

  devise_for :users, :path => '', 
                     :path_names => { :sign_in => "login", 
                                      :sign_out => "logout", 
                                      :sign_up => "sign-up", 
                                      :account_update => "account-settings" },
                     :controllers => { omniauth_callbacks: "authentications", registrations: "registrations" }

  get "/auth/:provider/callback", to: "authentications#:provider"
  
  #devise_scope :user do
  #  get "/registrations/catch", to: "registrations#catch"
  #end

  # vcap.me:3000
  # evaluates to 127.0.0.1:3000
  # Use as localhost:3000 substitute for callback url in provider app settings.

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
