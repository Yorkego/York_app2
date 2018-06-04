Rails.application.routes.draw do
  
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
	  root "posts#index"	  

	  devise_for :users
	  resources :posts	  
	  resources :tags, only: [:show]
	  resources :profiles	  
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
