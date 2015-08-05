require_relative '../spec_helper'

describe ProductsController do
  let(:product) { Product.new(name: 'pen', price: 12) }

  let(:app) {
    Rack::Builder.new do
      eval(File.read(TinyMVC.root + '/config.ru'))
    end
  }

  context '#create' do
    it do
      expect { post '/products', 'product' => {name: 'lapiz', price: 3} }.to change { Product.count }.to(1)
    end

    it do
      post '/products', 'product' => {name: 'lapiz', price: 3}
      expect(last_response).to be_redirect
    end
  end
end
