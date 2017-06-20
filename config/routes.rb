Rails.application.routes.draw do
  # get 'new_action', to: 'foreman_probing/hosts#new_action'
  namespace :foreman_probing do
    resources :scans, :only => [:create, :new, :show, :index]
  end
end
