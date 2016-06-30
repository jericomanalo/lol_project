Rails.application.routes.draw do

  #home/landing page
  root 'profiles#index'

  # --------------- Users Routes -----------------
  get 'signup' => 'users#index'
  post 'users' => 'users#create'
  get 'masteryDex' => 'users#show'

  # --------------- Sessions Routes -----------------
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

  # --------------- Profile Routes -----------------
  #search summoner profile
  post 'profiles/search' => 'profiles#search'

  get 'profiles/home' => 'profiles#show'
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
  get 'profiles/:summonerName1/:region1/graph/:championId/compare/:summonerName2/:region2' => 'profiles#show_compare'

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
