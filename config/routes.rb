Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :slides do
      collection do
        post :update_positions
      end
    end

    resources :slide_locations
  end

  namespace :api, :defaults => { :format => 'json' } do
    namespace :v1 do
      resources :slide_locations do
      end
    end
  end
end
