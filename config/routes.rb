Deals::Application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :items, controller: "products", only: [:new, :edit, :create, :update, :destroy]
  end

  # /brands/:id(slug)/items
  # /brands/:id(slug)/items/:id(uuid)
  resources :brands, controller: "users", only: [] do
    namespace :sales do
      resources :items, controller: "products", only: [:index, :show]
    end
  end

  # /categories/:id(slug)/items
  resources :categories, only: [] do
    namespace :sales do
      resources :items, controller: "products", only: [:index]
    end
  end

  root to: 'static_pages#home'



  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # match ':controller(/:action(/:id))(.:format)'
end
