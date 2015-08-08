require_relative '../spec_helper'

describe ProductsController do
  let(:product) { Product.create(name: 'pen', price: 12) }

  let(:app) {
    Rack::Builder.new do
      eval(File.read(TinyMVC.root + '/config.ru'))
    end
  }

  context '#index' do
    it do
      get '/products'
      expect(last_response).to be_ok
    end
  end

  context '#new' do
    it do
      get '/products/new'
      expect(last_response).to be_ok
    end
  end

  context '#create' do
    it do
      expect { post '/products', 'product' => {name: 'lapiz', price: 3} }.to change { Product.count }.by(1)
    end

    it do
      post '/products', 'product' => {name: 'lapiz', price: 3}
      expect(last_response).to be_redirect
    end
  end

  context '#show' do
    it do
      get "/products/#{product.id}"
      expect(last_response).to be_ok
    end
  end

  context '#edit' do
    it do
      get "/products/#{product.id}/edit"
      expect(last_response).to be_ok
    end
  end

  context '#update' do
    it do
      expect {
        patch "/products/#{product.id}", 'product' => {price: 3}
      }.to change { Product.find(product.id).price.to_i }.from(12).to(3)
    end

    it do
      patch "/products/#{product.id}", 'product' => {name: 'lapiz', price: 3}
      expect(last_response).to be_redirect
    end
  end

  context '#destroy' do
    it do
      expect {
        delete "/products/#{product.id}"
      }.to change { Product.find(product.id) }.to(nil)
    end

    it do
      delete "/products/#{product.id}"
      expect(last_response).to be_redirect
    end
  end
end
