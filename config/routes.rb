Rails.application.routes.draw do

  resources :users do
    resources :statements
  end

  devise_for :users, :path => 'accounts'

  devise_scope :user do
    root 'devise/sessions#new'
  end

  get '*path' => redirect('/')

end
