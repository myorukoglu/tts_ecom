Rails.application.routes.draw do
  root 'storefront#all_items'

  post 'add_to_cart' => 'cart#add_to_cart'

  get 'view_order' => 'cart#view_order'

  get 'checkout' => 'cart#checkout'
  
  post 'order_complete' => 'cart#order_complete'
  
  devise_for :users
  
  get 'categorical' => 'storefront#items_by_category' 

  get 'branding' => 'storefront#items_by_brand'
  
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
