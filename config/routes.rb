Rails.application.routes.draw do
  root to: "application#heartbeat"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :rules
end
