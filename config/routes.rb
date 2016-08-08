Rails.application.routes.draw do
  resources :users

  #home/landing page
  root 'summoners#index'

  # --------------- Users Routes -----------------
  get 'signup' => 'users#index'
  post 'users' => 'users#create'
  post 'users/search' => 'users#search'
  get 'users/:id' => 'users#show'
  get 'users/:name/edit' => 'users#edit'
  post 'users/:name/update' => 'users#update'
  post 'users/favorite' => 'users#favorite'
  post 'users/unfavorite' => 'users#unfavorite'

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships,       only: [:create, :destroy]
  # --------------- Sessions Routes -----------------
  get 'dashboard' => 'sessions#index'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

  # --------------- Summoners Routes -----------------
  #search summoner Summoners
  post 'summoners/search' => 'summoners#search'

  get 'summoners/home' => 'summoners#show'
  #create summoner Summoners - if not in DB
  post 'summoners' => 'summoners#create'
  #show summoner Summoners
  get 'summoners/:summonerName/:region' => 'summoners#show'
  #update summoner Summoners
  patch 'summoners/:id/update' => 'summoners#update'
  #show graphs for summoner
  get 'summoners/:id/graph/:championId' => 'summoners#show_graph'
  #search comparison user in case not in DB
  post 'summoners/compare' => 'summoners#compare'
  #compare graphs with another user
  get 'summoners/:summonerName1/:region1/graph/:championId/compare/:summonerName2/:region2' => 'summoners#show_compare'

  # ---------------- ChampionMastery Routes -------------------
  #create champion_masteries - if not in DB
  get 'champion_masteries/create' => 'champion_masteries#create'

  get 'champion_masteries/update'

  # ---------------- Matches Routes -------------------
  #create matches - if not in DB
  post 'matches/create' => 'matches#create'

  get 'matches/:id' => 'matches#show'

  get 'matches/update'



end
