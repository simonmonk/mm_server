Rails.application.routes.draw do

  resources :regions
  resources :reminders
  resources :communications
  resources :users
  resources :product_categories
  resources :part_categories
  resources :transactions
  resources :suppliers
  resources :product_retailers
  
  get '/sales_uk/', to: 'welcome#sales_uk'
  get '/sales_us/', to: 'welcome#sales_us'
    
  get 'shipments/invoice/*other', to: 'shipments#invoice'
  get 'shipments/order_details/*other', to: 'shipments#order_details'
  get 'shipments/packing_list/*other', to: 'shipments#packing_list'
  get 'shipments/quote/*other', to: 'shipments#quote'
  get 'products/pricelist', to: 'products#pricelist'
  get 'products/productlist', to: 'products#productlist' # for the MM website 
  get 'retailers/retailer_list_website', to: 'retailers#retailer_list_website' # for the MM website 
  get 'prospects/countries.json', to: 'prospects#countries'

  resources :parts do
    collection do
      get :add_supplier
      get :remove_part_supplier
      get :export_parts
    end
  end
  resources :prospects do
    collection do
    end
  end

  resources :products do
    collection do
      get :deduct_stock
      get :add_part
      get :add_assembly
      get :delete_part
      get :delete_assembly
      get :sales_by_product
      get :sales_report
      get :image_links
    end
  end
  resources :assemblies do
    collection do
      get :deduct_stock
      get :add_part
      get :delete_part
      get :stock_report
    end
  end
  resources :retailers do
    collection do
      get :add_product
    end
  end
  resources :shipments do
    collection do
      get :add_product
      post :add_product
      get :import_shipment_uk
      get :import_shipment_com
      get :subtract_products
      get :un_subtract_products
      get :delete_shipment_line
      get :invoice
      get :order_details
      get :packing_list
      get :retailer_list_website
      get :list
      get :get_shipments
    end
  end
  resources :order_ins do
    collection do
      get :add_part
      get :delete_part
      get :rx_part
      get :save_part
      get :po
      get :qr
    end
  end
  resources :apis do
    collection do
      get :import_orders_amazon_uk
      get :import_all_orders
      get :check_stock_levels
      get :nightly
      get :check_orders_email
    end
  end
    
  resources :welcome do
      collection do
          get :dismiss_notification
          get :restore_notifications
      end
  end

  
    
  root 'welcome#index'
end
