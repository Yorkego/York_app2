Rails.application.routes.draw do
  get 'profile/show'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
	  root "posts#index"

	  devise_for :users
	  resources :posts
	  resources :profiles
	  resources :tags, only: [:show]	  
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
