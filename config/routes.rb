Rails.application.routes.draw do
	devise_for :users, controllers: { sessions: "sessions", registrations: "registrations" }

  resources :categories do
    resources :products do
      resources :reviews
    end
  end

  post 'admin/set_to' => "admin#set_to"

  root 'categories#index'
end
