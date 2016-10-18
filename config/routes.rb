Rails.application.routes.draw do
  
  resources :gifts do
    collection { post :import }
  end
  
  resources :donors do
    collection { post :import }
  end
  
  resources :activities, only: [:new, :create, :edit, :update, :index, :destroy] do
    collection { post :import }
  end

  get    '/home',    to: 'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/reports', to: 'static_pages#reports'
  get    '/import-export', to: 'static_pages#import_export'
  
  get 'import-export/import'
  get 'import-export/inkind'
  get 'import-export/export'
  
  root 'static_pages#home'
end