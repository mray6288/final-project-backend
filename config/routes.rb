Rails.application.routes.draw do
  
	namespace :api do 
	  	namespace :v1 do
	  		post '/login', to: "auth#login"
			post '/signup', to: "users#create"
			get '/get_user', to: "auth#get_user"
	  		# resources :user_targets
			# resources :targets
			# resources :friendships
			# resources :users
		end
	end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
