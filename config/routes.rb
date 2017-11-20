Rails.application.routes.draw do
  # get 'new_action', to: 'foreman_probing/hosts#new_action'
  namespace :foreman_probing do
    resources :scans, :only => [:create, :new, :show, :index] do
      member do
        get :rerun
      end
    end

    constraints(:id => /[^\/]+/) do
      resources :hosts do
        member do
          get 'open_ports'
        end
      end
    end

    namespace :api do
      scope "(:apiv)", :module => :v2, :defaults => {:apiv => 'v2'}, :apiv => /v2/, :constraints => ApiConstraints.new(:version => 2, :default => true) do
        resources :scans, :only => [:create, :index, :show] do
          member do
            get :rerun
          end
        end
      end
    end
  end
end
