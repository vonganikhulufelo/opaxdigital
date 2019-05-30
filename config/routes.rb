Rails.application.routes.draw do
  resources :customer_rebates
  resources :supliers, :cutomers, :only => [:show] do
    resources :payments, :only => [:show] do
      resources :zones, :only => [:show] do
        resources :products, :only => [:show] do 
          get '/supplier_rebates/:id', to: 'supplier_rebates#show', as: :rabate
          get '/customer_rebates/:id', to: 'customer_rebates#show', as: :cust_rabate
        end
      end
    end
  end
  get 'payment/:id', to: 'supplier_orders#payment'
  get 'zone/:id', to: 'supplier_orders#zone'
  get 'product_name/:id', to: 'supplier_orders#product_name'
  get 'product_price/:id', to: 'supplier_orders#product_price'

  get 'customer_payment/:id', to: 'customer_orders#payment'
  get 'customer_zone/:id', to: 'customer_orders#zone'
  get 'customer_product_name/:id', to: 'customer_orders#product_name'
  get 'customer_product_price/:id', to: 'customer_orders#product_price'


  resources :product, :only => [:show] do
    get '/getprices/:id', to: 'getprices#pricing', as: :pricing
  end

  resources :sales_orders
  get 'sales_orders/step2/:id', to: 'sales_orders#step2', as: :pick_up
  resources :purchase_orders
  get 'purchase_orders/step2/:id', to: 'purchase_orders#step2', as: :step2
  get 'purchase_orders/step3/:id', to: 'purchase_orders#step3', as: :step3
  get 'purchase_orders/step4/:id', to: 'purchase_orders#step4', as: :step4
  put "purchase_orders/step22/:id" => 'purchase_orders#step22', as: :step22
  put "purchase_orders/step33/:id" => 'purchase_orders#step33', as: :step33
  resources :supplier_rebates, only: [:index, :new, :edit, :create, :destroy]
  resources :customers
  resources :suppliers
  resources :payment_terms
  resources :product_prices do
    collection { post :import }
  end
  resources :product_descriptions do
    collection { post :import }
  end
  resources :magisterial_districts do
    collection { post :import }
  end
  resources :users
  post "supplier_rebates/payment" => 'supplier_rebates#payment', as: :payment
  post "supplier_rebates/zone" => 'supplier_rebates#zone', as: :zone
  post "supplier_rebates/rebate" => 'supplier_rebates#rebate', as: :rebate
  post "customer_rebates/crebate" => 'customer_rebates#crebate', as: :crebate
  delete '/remove_product/:id' => 'supplier_rebates#remove_product', as: :remove_supplier_product
  delete '/remove_supplier_zone/:id' => 'supplier_rebates#remove_zone', as: :remove_supplier_zone
  delete '/remove_customer_product/:id' => 'customer_rebates#remove_product', as: :remove_customer_product
  delete '/remove_customer_zone/:id' => 'customer_rebates#remove_zone', as: :remove_customer_zone
  get '/price_lookup', to: 'price_lookups#index'
  root "sessions#new"
  get '/login',  to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
