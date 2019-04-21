Rails.application.routes.draw do
  resources :theaters, except: %i[show delete]
  root to: 'theaters#index'
end
