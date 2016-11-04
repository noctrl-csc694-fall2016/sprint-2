Rails.application.routes.draw do
  
  get 'trash/index'

  get 'trash/show'

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
  
  resources :trashes, only: [:index]
  
  get    '/home',    to: 'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/reports', to: 'static_pages#reports'
  
  get    '/import-export', to: 'static_pages#import_export'
  get    '/import', to: 'import_export#import'
  get    '/inkind', to: 'import_export#inkind'
  get    '/export', to: 'import_export#export'
  
  get    '/report-activities', to: 'reports#activities_setup'
  post   '/report-activities-pdf', to: 'reports#activities_report'
  get    '/report-donors', to: 'reports#donors_setup'
  post   '/report-donors-pdf', to: 'reports#donors_report'
  get    '/report-gifts', to: 'reports#gifts_setup'
  post   '/report-gifts-pdf', to: 'reports#gifts_report'
  post   '/report-trash-pdf', to: 'reports#trash_report'
  
  get    'hyper-surf/donors', to: 'hyper_surf#donors'
  get    'hyper-surf/all', to: 'hyper_surf#all'
  
  root 'static_pages#home'
end