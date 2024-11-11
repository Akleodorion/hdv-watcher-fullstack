Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  
  # Defines the root path route ("/")
  root "items#index"

  namespace :api do   
      namespace :v1 do
        resources :items, only: %i[show index] 
       
        namespace :seeds do
          post 'populate'
          get 'infos'
        end
    
        namespace :scraps do
          post 'entry'
          get 'infos'
        end
      end
  end
  resources :items, only: %i[index show]
end
