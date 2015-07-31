TinyMVC::Router.draw do
  root controller: 'products', action: 'index'
  get '/products', controller: 'products', action: 'index'
  get '/products/:id.:format', controller: :products, action: :show
  post '/cart', controller: 'cart', action: 'update'
  get '/cart', controller: 'cart', action: 'show'
end
