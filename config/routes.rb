Rails.application.routes.draw do
  post "logout" => "users#logout"
  post "login" => "users#login"
  get "login" => "users#login_form"
  post "users/:id/destroy" => "users#destroy"
  get "users/:id/edit" => "users#edit"
  post "users/:id/update" => "users#update"
  post "users/create" => "users#create"
  get "/signup" => "users#new"
  get 'users/index' => "users#index"
  get "users/:id" => "users#show"

  get 'posts/index' => "posts#index"
  get "posts/new" => "posts#new"
  get "posts/:id" => "posts#show"
  post "posts/create" => "posts#create"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/destroy" => "posts#destroy"
  
  get '/' => "home#top"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
