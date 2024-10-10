# frozen_string_literal: true

Rails.application.routes.draw do
  # get 'reports/show'
  root 'official_diarys#index'

  # Route for healthcheck
  get '/up/', to: 'up#index', as: :up
  get '/up/databases', to: 'up#databases', as: :up_databases

  # Rails Admin
  devise_for :users
  namespace :admin do
    resources :sections do
      member do
        get :show, defaults: { format: :pdf }
      end
    end
    resources :file_sections, only: [:destroy]
    resources :official_diarys do
      member do
        get 'download_text_pdf/:section_id', action: :download_text_pdf, as: :download_text_pdf
        get :download_combined_pdf, as: :download_combined_pdf
        post :publish_diary, as: :publish_diary
      end
    end

    resources :branch_governments
    resources :diary_sub_categorys
    resources :diary_categorys do
      get 'subcategories', on: :member
    end
    resources :entitys do
      member do
        post 'log_entity'
      end
    end
    resources :type_entitys
    resources :offices
    resources :users
    root 'dashboard#index'
    namespace :services do
      post '/remove_image', to: 'delete_images#remove_image'
    end
  end

  # Contact
  post 'fale-conosco' => 'contacts#create', as: :create_contact
  get 'fale-conosco' => 'contacts#index', as: :contact

  get 'busca' => 'searchs#index', as: :search
end
