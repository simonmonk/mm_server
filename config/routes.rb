Rails.application.routes.draw do

  resources :adjustment_types
  resources :assembly_categories
  resources :expenses
  
  resources :book_keeping_categories
  resources :cost_centres
  resources :regions
  resources :reminders
  resources :communications
  resources :users
  resources :product_categories
  resources :part_categories
  resources :transactions
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
  get 'suppliers/suppliers_list.json', to: 'suppliers#suppliers_list'
  get 'products/:id/print_labels/:qty', to: 'products#print_labels#qty'
  get 'bookkeepings/transactions', to: 'bookkeepings#transactions'
  get 'bookkeepings/create_spreadsheet', to: 'bookkeepings#create_spreadsheet'
  get 'bookkeepings', to: 'bookkeepings#index'
  get 'parts/:id/set_inactive/', to: 'parts#set_inactive'
  

  resources :hs_codes do
    collection do
      get :extract_hs_codes_from_products
    end
  end  

  
  resources :accounts do
    collection do
      get :cashflow
      post :vatObligations
      get :vat
      get :vat_obligations
      get :vat_report
      get :vatSummary
      post :submit_vat_return
    end
  end
    
  resources :adjustments do
    collection do
      get :amazon_countries
      get :amazon_months
      post :generate_amazon_adjustments
    end
  end
  

  resources :expenses do
    collection do
      post :import_receipt  
    end
  end

  resources :parts do
    collection do
      get :add_supplier
      get :remove_part_supplier
      get :export_parts
      get :stock_label
      get :set_inactive
      get :reel_calc
    end
  end

  resources :prospects do
    collection do
      get :export_csv
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
      get :pricelist_csv
      get :product_id_from_barcode
      get :print_labels
      get :stock_label
      get :bring_all_prices_inline_with_catalog
    end
  end
  resources :assemblies do
    collection do
      get :deduct_stock
      get :add_part
      get :delete_part
      get :stock_report
      get :stock_label
    end
  end
  resources :retailers do
    collection do
      get :add_product
      get :copy_product_retailers
      get :export_csv
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
      get :get_shipments
      get :weekly_sales
      get :monthly_sales
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
      get :list
      get :get_orders_json
      post :create_order_in
      post :update_order_in
      get :add_part_json
      get :edit_part_json
      post :rx_part_json
      post :rx_non_part_json
      get :delete_line_item
      post :set_new_part_price_json
      get :delete_json
      post :import_invoice
      post :upload
      get :rnd_report
      get :document_list
    end
  end
  resources :suppliers do
    collection do
      get :suppliers_list
      get :tax_regions
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
          get :financial
      end
  end

  resources :settings do
    collection do
        get :set_test_env
    end
  end

  resources :website do
    collection do
      get :index  
      get :home
      get :product_page
      get :generate_files
      get :upload_files
      get :products
    end
  end

  root 'welcome#index'
end
