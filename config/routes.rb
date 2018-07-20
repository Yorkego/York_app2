Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do


	  root "posts#index"

	  devise_for :users
	  resources :posts do
      resources :comments
	  	member do
	  		put "like", to: "posts#upvote"
	    end
	  end
    resources :comments do
      resources :comments
    end
	  resources :users
	  resources :tags, only: [:show]
    resources :friendships, only: [:create, :update, :destroy]
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
