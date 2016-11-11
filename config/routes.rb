Rails.application.routes.draw do

  get 'users/index'

  get 'users/show'

  get 'users/edit'

  get 'users/create'

  get 'users/update'

  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  get 'reports/activities'

  get 'reports/donors'

  get 'reports/gifts'

  #----------------------------------#
  # Gift Garden Routes File
  # original written by: Andy W, Oct 14 2016
  # major contributions by:
  #             Wei H, Oct 16 2016
  #----------------------------------#
  
  resources :gifts, only: [:new, :create, :edit, :update, :index, :destroy] do
    collection { post :import }
    collection { post :inkind }
  end
  resources :donors, only: [:new, :create, :edit, :update, :index, :destroy] do
    collection { post :import }
  end
  resources :activities, only: [:new, :create, :edit, :update, :index, :destroy] do
    collection { post :import }
  end
  
  resources :trashes
  
  get    '/home',    to: 'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/reports', to: 'static_pages#reports'
  
  get    '/import-export', to: 'static_pages#import_export'
  get    '/import', to: 'import_export#import'
  get    '/inkind', to: 'import_export#inkind'
  get    '/export', to: 'import_export#export'
  get    '/import-gifts-begin', to: 'import_export#import_gifts_begin'
  get    '/import-gifts-next', to: 'import_export#import_gifts_next'
  post   '/import-gifts-validate', to: 'import_export#import_gifts_validate'
  get    '/import-gifts-success', to: 'import_export#import_gifts_success'
  
  get    '/report-activities', to: 'reports#activities_setup'
  post   '/report-activities-pdf', to: 'reports#activities_report'
  get    '/report-donors', to: 'reports#donors_setup'
  post   '/report-donors-pdf', to: 'reports#donors_report'
  get    '/report-gifts', to: 'reports#gifts_setup'
  post   '/report-gifts-pdf', to: 'reports#gifts_report'
  post   '/trashes-trash-pdf', to: 'reports#trash_report'
  
  get    'hyper-surf/donors', to: 'hyper_surf#donors'
  get    'hyper-surf/activities', to: 'hyper_surf#activities'
  get    'hyper-surf/all', to: 'hyper_surf#all'
  
  get    'login'                  => 'sessions#new'
  post   'login'                  => 'sessions#create'
  delete 'logout'                 => 'sessions#destroy'
  
  resources :users
  
  root 'sessions#new'
end