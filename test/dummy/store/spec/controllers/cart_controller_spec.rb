require_relative '../spec_helper'

describe CartController do
  let(:app) {
    Rack::Builder.new do
      eval(File.read(TinyMVC.root + '/config.ru'))
    end
  }

  context '#show' do
    it do
      get '/cart'
      expect(last_response).to be_ok
    end
  end

  context '#update' do
    let(:product) { Product.create(name: 'pen', price: 12) }

    it do
      post "/cart", 'id' => product.id
      expect(last_response).to be_redirect
    end

    it do
      post "/cart", 'id' => -1
      expect(last_response.status).to eq(404)
    end
  end
end
