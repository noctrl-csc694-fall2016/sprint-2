  #----------------------------------#
  # Gift Garden Routes File
  # original written by: Andy W, Oct 14 2016
  # major contributions by:
  #             Wei H, Oct 16 2016
  #----------------------------------#

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
  post   '/import-gifts-import', to: 'import_export#import_gifts_import'
  post   '/import-gifts-validate', to: 'import_export#import_gifts_validate'
  get    '/import-gifts-inst', to: 'import_export#import_gifts_inst'
  get    '/import-gifts-step-one', to: 'import_export#import_gifts_step_one'
  post   '/import-gifts-download-csv-template', to: 'import_export#import_gifts_download_csv_template'
  get    '/import-gifts-step-two', to: 'import_export#import_gifts_step_two'
  get    '/import-gifts-step-three', to: 'import_export#import_gifts_step_three'
  
  get    '/report-activities', to: 'reports#activities_setup'
  post   '/report-activities-pdf', to: 'reports#activities_report'
  get    '/report-donors', to: 'reports#donors_setup'
  post   '/report-donors-pdf', to: 'reports#donors_report'
  get    '/report-gifts', to: 'reports#gifts_setup'
  post   '/report-gifts-pdf', to: 'reports#gifts_report'
  get    '/report-inkind_gifts', to: 'reports#inkind_setup'
  post   '/report-inkind-pdf', to: 'reports#inkind_report'
  get    '/report-one-donor', to: 'reports#one_donor_setup'
  post   '/report-one-donor-pdf', to: 'reports#one_donor_report'
  post   '/trashes-trash-pdf', to: 'reports#trash_report'
  get    '/report-new-donors', to: 'reports#new_donors_setup'
  post   '/report-new-donors-pdf', to: 'reports#new_donors_pdf'
  get    '/report-lybunt', to: 'reports#lybunt_setup'
  post   '/report-lybunt-pdf', to: 'reports#lybunt_report'
  
  get    '/hyper-surf/all', to: 'hyper_surf#all'
  
  get    'login'                  => 'sessions#new'
  post   'login'                  => 'sessions#create'
  delete 'logout'                 => 'sessions#destroy'
  
  get    'user-list'              => 'users#index'
  
  resources :users
  
  root 'sessions#new'
end