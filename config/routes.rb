Rails.application.routes.draw do
  resources :reverse_locations
  resources :meet_mes, only: :create

  get '/meetmehalfway' => 'meet_mes#start'
  post '/meetmehalfway' => 'meet_mes#pass'
  get '/meetmehalfway/new/:id' => 'meet_mes#new', as: 'new_meet_me'
  get '/meetmehalfway/:id' => 'meet_mes#show', as: 'meet_me'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
