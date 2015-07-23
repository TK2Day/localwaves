Rails.application.routes.draw do

  post "users", to: 'registrations#create'
  get 'users/oauth', to: 'registrations#oauth'
  post "users/sign_in", to: 'registrations#login'

  get "user/:id", to: 'users#show'
  #get 'user/update, to: 'users#updater
  delete "user/:id/token", to: 'users#reset'
  delete "user/:id", to: 'users#destroy'
  post "user/:id/sync", to: 'users#sync'

  get "user/:id/tracks", to: 'tracks#by_user'
  get "tracks", to: 'tracks#index'
  get "tracks/search", to: 'tracks#search'
  get "tracks/completion", to: 'tracks#completion'

  # get 'users/oauth_test', to: 'registrations#oauth_test'

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
