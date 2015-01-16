Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :maps do
        resources :map_places
        member do
          get 'd3_current'
          get 'd3'
          get 'infographic'
        end
      end
    end
  end

end
