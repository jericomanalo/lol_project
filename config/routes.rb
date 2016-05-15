Rails.application.routes.draw do
  #home/landing page
  root 'profiles#index'

  # --------------- Profile Routes -----------------
  #search summoner profile
  post 'profiles/search' => 'profiles#search'
  #create summoner profile - if not in DB
  post '/profiles' => 'profiles#create'
  #show summoner profile
  get 'profiles/:summonerName/:region' => 'profiles#show'
  #update summoner profile
  patch 'profiles/:id/update' => 'profiles#update'
  #show graphs for summoner
  get 'profiles/:id/graph/:championId' => 'profiles#show_graph'
  #search comparison user in case not in DB
  post 'profiles/compare' => 'profiles#compare'
  #compare graphs with another user
  get 'profiles/:summonerName/graph/:championId/compare/:summonerName2' => 'profiles#show_compare'

  # ---------------- ChampionMastery Routes -------------------
  #create champion_masteries - if not in DB
  get 'champion_masteries/create' => 'champion_masteries#create'

  get 'champion_masteries/update'

  # ---------------- Matches Routes -------------------
  #create matches - if not in DB
  post 'matches/create' => 'matches#create'

  get 'matches/update'


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
