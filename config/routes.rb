Rails.application.routes.draw do
  get 'new_action', to: 'foreman_probing/hosts#new_action'
end
