Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :users, only: [:create, :show, :destroy] do
    collection do
      post '/login', to: 'users#login'
    end
  end
  resources :songs, only: [:create, :show, :update, :index, :destroy]
  resources :artists, only: [:create, :show, :update, :index, :destroy]
  resources :playlists do
   member do
     put '/add_song/:song_id', to: 'playlists#add_song'
     put '/remove_song/:song_id', to: 'playlists#remove_song'
   end
  end
end
