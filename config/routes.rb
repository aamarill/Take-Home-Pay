Rails.application.routes.draw do

  resources :statements

  devise_for :users

  devise_scope :user do
    root 'devise/sessions#new'
  end

end
