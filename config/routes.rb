Rails.application.routes.draw do
  resources :hacks
  resources :colorschemas
  resources :dotfiles
  devise_for :users
  resources :users
  resources :plugins
  get 'plugins_tags/:tag', to: 'plugins#index', as: :plugins_tags
  get 'posts_tags/:tag', to: 'posts#index', as: :posts_tags
  get 'hacks_tags/:tag', to: 'hacks#index', as: :hacks_tags
  get 'plugins_vote/:id', to: 'plugins#vote', as: :plugins_vote
  get 'hacks_vote/:id', to: 'hacks#vote', as: :hacks_vote
  get 'view_log', to: 'users#view_log', as: :log
  get 'search', to: 'search#search', as: :search
  get 'view_plugins_list', to: 'users#view_plugins_list', as: :plugins_list
  post 'create_dotfile', to: 'users#create_dotfile', as: :create_dotfile
  resources :posts

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  root 'users#index'

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
