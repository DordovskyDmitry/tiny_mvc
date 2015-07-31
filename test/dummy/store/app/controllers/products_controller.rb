class ProductsController < TinyMVC::ApplicationController
  layout 'app/views/layout.html.erb'

  def index
    @products = Product.all
    render 'app/views/products/index'
  end

  def show
    @product = Product.find(params['id'])
    render 'app/views/products/show'
  end
end
