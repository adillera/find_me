FindMe::Application.routes.draw do
  root to: 'main#index'

  resources :login, only: %w(index create)
  resources :main, only: ['index'] do
    collection do
      delete :logout
    end
  end
end
