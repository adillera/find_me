FindMe::Application.routes.draw do
  root to: 'main#index'

  resources :login, only: ['index', 'create']
end
