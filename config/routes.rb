Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root "static_pages#home"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get  "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/search", to: "questions#search", as: "search_page"
  get "/autocomplete", to: "questions#autofilltext"
  post "/vote/:id", to: "answers#vote", as: "vote"
  delete "/unvote/:id", to: "answers#unvote", as: "unvote"

  resources :users
  resource :password_resets, only: [:new, :create, :edit, :update]
  resources :questions do
    resources :answers
    resources :comments
  end
end
