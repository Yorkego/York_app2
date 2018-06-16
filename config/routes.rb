Rails.application.routes.draw do
  
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
	  root "posts#index"

	  post ":id/users/invite", to: 'users#invite'

	  devise_for :users
	  resources :posts	  
	  resources :users 
	  resources :tags, only: [:show]	    
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
