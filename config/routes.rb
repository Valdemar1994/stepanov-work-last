Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  devise_for :user, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: "pools#index"

    resources :pools do
      collection do
        get :pool_graph, to: 'pools#pool_graph'
      end
    end

  resources :snapshots do
    get :snapshot_graph, to: 'snapshots#snapshot_graph'
  end
end
