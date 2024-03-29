Rails.application.routes.draw do
  
  resources :users do
    collection do
      get 'search'
    end
  end
  
  resources :videos
   post 'video/:id' => 'homes#top'
   resources :video, only: [:index, :new, :create,:edit ,:update, :destroy]

    devise_for :admin, controllers: {
      sessions: 'admin/sessions',
    }

    namespace :admin do
      get 'top' => 'homes#top', as: 'top'
      get 'customers/:customer_id/orders' => 'orders#index', as: 'customer_orders'
      resources :customers, only: [:index, :show, :edit, :update]
      resources :items, except: [:destroy]
      resources :orders, only: [:index, :show, :update] do
        resources :order_details, only: [:update]
      end
    end


    devise_for :customers, controllers: {
      sessions: 'public/sessions',
      registrations: 'public/registrations',
    }

    scope module: :public do
      root 'homes#top'

      get 'customers/mypage' => 'customers#show', as: 'mypage'
      get 'customers/information/edit' => 'customers#edit', as: 'edit_information'
      patch 'customers/information' => 'customers#update', as: 'update_information'
      get 'customers/unsubscribe' => 'customers#unsubscribe', as: 'confirm_unsubscribe'
      put 'customers/information' => 'customers#update'
      patch 'customers/withdraw' => 'customers#withdraw', as: 'withdraw_customer'
      delete 'cart_items/destroy_all' => 'cart_items#destroy_all', as: 'destroy_all_cart_items'
      post 'orders/confirm' => 'orders#confirm'
      get 'orders/confirm' => 'orders#error'
      get 'orders/thanks' => 'orders#thanks', as: 'thanks'

      resources :homes

      resources :addresses, only: [:index, :create, :edit, :update, :destroy]
      resources :items, only: [:index, :show] do
        resources :cart_items, only: [:create, :update, :destroy]
      end
      resources :cart_items, only: [:index]
      resources :orders, only: [:new, :index, :create, :show]

    end

      resources :items, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
        resource :favorites, only: [:create, :destroy]
        resources :comments, only: [:create, :destroy]
      end


 end
