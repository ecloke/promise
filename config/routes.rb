Rails.application.routes.draw do
  resources :comments
  devise_for :users
  resources :achievements do
  	member do
  		post 'like', to: "achievements#upvote"
  		post 'dislike', to: "achievements#downvote"
  	end

    resources :comments
  end

  get '/bn_promises' => "achievements#bn_promises"
  get '/ph_promises' => "achievements#ph_promises"
  get '/opinions' => "achievements#opinions"
  get '/my_activity' => "achievements#my_activity"
  get '/admin' => "achievements#admin"
  root "achievements#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
