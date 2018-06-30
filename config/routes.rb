Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
	  root "posts#index"

	  devise_for :users
	  resources :posts do
	  	member do
	  		put "like", to: "posts#upvote"
	    end
	  end
	  resources :users
	  resources :tags, only: [:show]
    resources :friendships, only: [:create, :update, :destroy]
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
